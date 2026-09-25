import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/inspection_repository.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'inspection_screen.dart';
import 'new_inspection_screen.dart';
import 'property_form_screen.dart';

class PropertyScreen extends ConsumerWidget {
  const PropertyScreen({
    super.key,
    required this.propertyId,
    this.offerFirstInspection = false,
  });

  final String propertyId;
  final bool offerFirstInspection;

  void _newInspection(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => NewInspectionScreen(propertyId: propertyId),
    ),
  );

  Future<void> _delete(BuildContext context, WidgetRef ref, Property p) async {
    final ok = await confirmAction(
      context,
      title: 'Delete "${p.nickname}"?',
      message:
          'This permanently deletes every inspection, photo, video and report '
          'for this place from this phone. Files you already shared or '
          'exported are not affected. This cannot be undone.',
      confirmLabel: 'Delete everything',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final navigator = Navigator.of(context);
    final done = await runGuarded(context, () async {
      await ref.read(propertyRepositoryProvider).delete(p.id);
      return true;
    });
    if (done == true) navigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final property = ref.watch(propertyProvider(propertyId));
    final inspections = ref.watch(inspectionSummariesProvider(propertyId));
    return AsyncView(
      value: property,
      builder: (p) {
        if (p == null) return const Scaffold(body: SizedBox.shrink());
        final address = [
          p.addressLine1,
          p.addressLine2,
          [p.city, p.region, p.postalCode].where((s) => s.isNotEmpty).join(' '),
        ].where((s) => s.trim().isNotEmpty).join('\n');
        return Scaffold(
          appBar: AppBar(
            title: Text(p.nickname, overflow: TextOverflow.ellipsis),
            actions: [
              PopupMenuButton<String>(
                tooltip: 'More options',
                onSelected: (v) {
                  if (v == 'edit') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PropertyFormScreen(existing: p),
                      ),
                    );
                  } else if (v == 'delete') {
                    _delete(context, ref, p);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit details')),
                  PopupMenuItem(value: 'delete', child: Text('Delete place')),
                ],
              ),
            ],
          ),
          floatingActionButton: inspections.maybeWhen(
            data: (list) => list.isEmpty
                ? null
                : FloatingActionButton.extended(
                    onPressed: () => _newInspection(context),
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('New inspection'),
                  ),
            orElse: () => null,
          ),
          body: AsyncView(
            value: inspections,
            builder: (list) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                if (address.isNotEmpty)
                  Text(address, style: Theme.of(context).textTheme.bodyLarge),
                if (p.landlordName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Landlord / manager: ${p.landlordName}'),
                  ),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  _FirstInspectionCard(onStart: () => _newInspection(context))
                else ...[
                  Semantics(
                    header: true,
                    child: Text(
                      'Inspection history',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final s in list) ...[
                    _InspectionCard(summary: s),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FirstInspectionCard extends StatelessWidget {
  const _FirstInspectionCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready for your walkthrough?',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Go room by room and photograph what you see, especially '
              'anything already damaged, dirty or not working. Your lease or '
              'local rules may set a short deadline for recording move-in '
              'condition, so it helps to do this in the first days.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start inspection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({required this.summary});

  final InspectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final i = summary.inspection;
    final scheme = Theme.of(context).colorScheme;
    final completed = i.status == InspectionStatus.completed;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InspectionScreen(inspectionId: i.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${inspectionTypeLabel(i.type)} inspection',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  StatusLabel(
                    icon: completed
                        ? Icons.check_circle_outline
                        : Icons.pending_outlined,
                    label: completed ? 'Finished' : 'In progress',
                    color: completed
                        ? StatusColors.done(scheme)
                        : StatusColors.warning(scheme),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Started ${dateTimeFormat.format(i.startedAt)}'),
              const SizedBox(height: 4),
              Text(
                '${summary.completedRoomCount} of ${summary.roomCount} rooms '
                'done · ${count(summary.mediaCount, 'photo/video', 'photos/videos')} · '
                '${count(summary.issueCount, 'issue')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
