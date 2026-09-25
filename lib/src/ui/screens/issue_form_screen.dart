import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/evidence_repository.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../widgets/common.dart';

class IssueFormScreen extends ConsumerStatefulWidget {
  const IssueFormScreen({
    super.key,
    required this.roomId,
    this.existing,
    this.initialMediaId,
    this.readOnly = false,
  });

  final String roomId;
  final Issue? existing;
  final String? initialMediaId;
  final bool readOnly;

  @override
  ConsumerState<IssueFormScreen> createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends ConsumerState<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title);
  late final _description = TextEditingController(
    text: widget.existing?.description,
  );
  late IssueCategory _category =
      widget.existing?.category ?? IssueCategory.damage;
  late IssueSeverity _severity =
      widget.existing?.severity ?? IssueSeverity.minor;
  late String? _mediaId = widget.existing?.mediaId ?? widget.initialMediaId;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(evidenceRepositoryProvider);
    final input = IssueInput(
      title: _title.text,
      description: _description.text,
      category: _category,
      severity: _severity,
      mediaId: _mediaId,
    );
    final saved = await runGuarded(
      context,
      () => widget.existing == null
          ? repo.addIssue(widget.roomId, input)
          : repo.updateIssue(widget.existing!.id, input),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved != null) Navigator.of(context).pop(saved.id);
  }

  Future<void> _delete() async {
    final ok = await confirmAction(
      context,
      title: 'Delete this issue?',
      message: 'The issue and its photo markers will be removed.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final navigator = Navigator.of(context);
    final done = await runGuarded(context, () async {
      await ref
          .read(evidenceRepositoryProvider)
          .deleteIssue(widget.existing!.id);
      return true;
    });
    if (done == true) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final media = ref.watch(roomMediaProvider(widget.roomId)).value ?? const [];
    final photos = media.where((m) => m.kind == MediaKind.photo).toList();
    final evidence = ref.read(evidenceRepositoryProvider);
    final ro = widget.readOnly;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ro
              ? 'Issue'
              : widget.existing == null
              ? 'Add issue'
              : 'Edit issue',
        ),
        actions: [
          if (widget.existing != null && !ro)
            IconButton(
              tooltip: 'Delete issue',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              readOnly: ro,
              maxLength: 120,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'What is the issue? *',
                hintText: 'e.g. Scratch on floor near window',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please describe the issue briefly'
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<IssueCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final c in IssueCategory.values)
                  DropdownMenuItem(
                    value: c,
                    child: Text(issueCategoryLabel(c)),
                  ),
              ],
              onChanged: ro ? null : (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            Text(
              'How noticeable?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<IssueSeverity>(
              segments: [
                for (final s in IssueSeverity.values)
                  ButtonSegment(value: s, label: Text(severityLabel(s))),
              ],
              selected: {_severity},
              onSelectionChanged: ro
                  ? null
                  : (v) => setState(() => _severity = v.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              readOnly: ro,
              maxLength: 4000,
              maxLines: 6,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Details (optional)',
                hintText: 'Size, exact location, anything you were told',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Photo showing it',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (photos.isEmpty)
              const Text(
                'No photos in this room yet. You can link a photo later.',
              )
            else
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _Selectable(
                        selected: _mediaId == null,
                        label: 'No photo linked',
                        onTap: ro
                            ? null
                            : () => setState(() => _mediaId = null),
                        child: const SizedBox(
                          width: 88,
                          height: 88,
                          child: Center(child: Text('None')),
                        ),
                      );
                    }
                    final m = photos[i - 1];
                    return _Selectable(
                      selected: _mediaId == m.id,
                      label: 'Link photo $i',
                      onTap: ro ? null : () => setState(() => _mediaId = m.id),
                      child: FileThumb(
                        path: evidence.thumbnailFilePath(m),
                        semanticLabel: 'Photo $i',
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            if (!ro)
              FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Save issue'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Selectable extends StatelessWidget {
  const _Selectable({
    required this.selected,
    required this.label,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final String label;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
              ),
              child: ExcludeSemantics(child: child),
            ),
            if (selected)
              Positioned(
                right: 4,
                top: 4,
                child: Icon(Icons.check_circle, color: scheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}
