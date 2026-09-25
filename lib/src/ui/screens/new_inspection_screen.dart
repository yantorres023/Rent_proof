import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../../services/room_templates.dart';
import '../widgets/common.dart';
import 'inspection_screen.dart';

const _typeHelp = {
  InspectionType.moveIn: 'When you get the keys, before unpacking.',
  InspectionType.moveOut: 'When you leave. Compare with your move-in record.',
  InspectionType.routine: 'Any time during the tenancy.',
  InspectionType.maintenance: 'Document a repair problem as it happens.',
};

class NewInspectionScreen extends ConsumerStatefulWidget {
  const NewInspectionScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<NewInspectionScreen> createState() =>
      _NewInspectionScreenState();
}

class _NewInspectionScreenState extends ConsumerState<NewInspectionScreen> {
  InspectionType _type = InspectionType.moveIn;
  List<Inspection> _baselines = const [];
  String? _baselineId;
  final Set<String> _rooms = {...defaultRoomKeys};
  bool _loading = true;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(inspectionRepositoryProvider);
    final candidates = await repo.baselineCandidates(widget.propertyId);
    final existing = await repo.watchSummaries(widget.propertyId).first;
    if (!mounted) return;
    setState(() {
      _baselines = candidates;
      _loading = false;
      // Suggest move-out once a move-in exists.
      if (existing.any((s) => s.inspection.type == InspectionType.moveIn)) {
        _selectType(InspectionType.moveOut);
      }
    });
  }

  void _selectType(InspectionType type) {
    _type = type;
    if (type == InspectionType.moveOut && _baselines.isNotEmpty) {
      final moveIn = _baselines.where((b) => b.type == InspectionType.moveIn);
      _baselineId = (moveIn.isNotEmpty ? moveIn.first : _baselines.first).id;
    } else if (type == InspectionType.moveIn) {
      _baselineId = null;
    }
  }

  Future<void> _start() async {
    setState(() => _starting = true);
    final navigator = Navigator.of(context);
    final inspection = await runGuarded(
      context,
      () => ref
          .read(inspectionRepositoryProvider)
          .create(
            propertyId: widget.propertyId,
            type: _type,
            roomTemplateKeys: [
              for (final t in roomTemplates)
                if (_rooms.contains(t.key)) t.key,
            ],
            baselineInspectionId: _baselineId,
          ),
    );
    if (!mounted) return;
    setState(() => _starting = false);
    if (inspection != null) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => InspectionScreen(inspectionId: inspection.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('New inspection')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Semantics(
                  header: true,
                  child: Text('What kind?', style: theme.textTheme.titleMedium),
                ),
                const SizedBox(height: 8),
                RadioGroup<InspectionType>(
                  groupValue: _type,
                  onChanged: (v) => setState(() => _selectType(v!)),
                  child: Column(
                    children: [
                      for (final t in InspectionType.values)
                        RadioListTile<InspectionType>(
                          value: t,
                          title: Text(inspectionTypeLabel(t)),
                          subtitle: Text(_typeHelp[t]!),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                if (_baselines.isNotEmpty) ...[
                  Semantics(
                    header: true,
                    child: Text(
                      'Compare with an earlier inspection',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Uses the same rooms and prompts so you can view them '
                    'side by side later.',
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: _baselineId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Baseline'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No comparison'),
                      ),
                      for (final b in _baselines)
                        DropdownMenuItem(
                          value: b.id,
                          child: Text(
                            '${inspectionTypeLabel(b.type)} · '
                            '${dateFormat.format(b.startedAt)}',
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() => _baselineId = v),
                  ),
                  const Divider(height: 32),
                ],
                if (_baselineId == null) ...[
                  Semantics(
                    header: true,
                    child: Text('Rooms', style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(height: 4),
                  const Text('You can add, rename or remove rooms later.'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in roomTemplates)
                        FilterChip(
                          label: Text(t.name),
                          selected: _rooms.contains(t.key),
                          onSelected: (on) => setState(
                            () => on ? _rooms.add(t.key) : _rooms.remove(t.key),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                FilledButton.icon(
                  onPressed: _starting ? null : _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start walkthrough'),
                ),
              ],
            ),
    );
  }
}
