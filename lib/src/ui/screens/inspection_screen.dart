import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/inspection_repository.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../../services/room_templates.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'comparison_screen.dart';
import 'report_screen.dart';
import 'review_screen.dart';
import 'room_screen.dart';

class InspectionScreen extends ConsumerWidget {
  const InspectionScreen({super.key, required this.inspectionId});

  final String inspectionId;

  Future<void> _addRoom(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('Add a room')),
            for (final t in roomTemplates)
              ListTile(
                leading: const Icon(Icons.meeting_room_outlined),
                title: Text(t.name),
                onTap: () => Navigator.pop(context, t.key),
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Custom room…'),
              onTap: () => Navigator.pop(context, ''),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    final repo = ref.read(inspectionRepositoryProvider);
    if (choice.isEmpty) {
      final name = await promptText(
        context,
        title: 'Room name',
        label: 'e.g. Office, Garage',
        confirmLabel: 'Add',
      );
      if (name == null || name.trim().isEmpty || !context.mounted) return;
      await runGuarded(
        context,
        () => repo.addRoom(inspectionId: inspectionId, customName: name),
      );
    } else {
      await runGuarded(
        context,
        () => repo.addRoom(inspectionId: inspectionId, templateKey: choice),
      );
    }
  }

  Future<void> _menu(
    BuildContext context,
    WidgetRef ref,
    String action,
    Inspection inspection,
  ) async {
    final repo = ref.read(inspectionRepositoryProvider);
    switch (action) {
      case 'notes':
        final notes = await promptText(
          context,
          title: 'Inspection notes',
          initial: inspection.notes,
          maxLength: 4000,
          maxLines: 6,
        );
        if (notes != null && context.mounted) {
          await runGuarded(
            context,
            () => repo.updateNotes(inspectionId, notes),
          );
        }
      case 'verify':
        final summary = await runGuarded(
          context,
          () => ref
              .read(evidenceRepositoryProvider)
              .verifyInspection(inspectionId),
        );
        if (summary != null && context.mounted) {
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('File check'),
              content: Text(
                summary.checked == 0
                    ? 'There are no files to check yet.'
                    : summary.allMatch
                    ? 'All ${summary.checked} stored files match the '
                          'fingerprints recorded when they were saved.'
                    : '${summary.matched} of ${summary.checked} files match. '
                          '${summary.mismatched} changed, '
                          '${summary.missing} missing. Changed or missing '
                          'files are marked in the photo details.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      case 'reopen':
        final ok = await confirmAction(
          context,
          title: 'Reopen inspection?',
          message:
              'You will be able to add or delete photos again. Reports you '
              'already generated stay as they were.',
          confirmLabel: 'Reopen',
        );
        if (ok && context.mounted) {
          await runGuarded(context, () => repo.reopen(inspectionId));
        }
      case 'delete':
        final ok = await confirmAction(
          context,
          title: 'Delete this inspection?',
          message:
              'All photos, videos, notes and reports of this inspection will '
              'be permanently deleted from this phone.',
          confirmLabel: 'Delete',
          destructive: true,
        );
        if (ok && context.mounted) {
          final navigator = Navigator.of(context);
          final done = await runGuarded(context, () async {
            await repo.deleteInspection(inspectionId);
            return true;
          });
          if (done == true) navigator.pop();
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionValue = ref.watch(inspectionProvider(inspectionId));
    final roomsValue = ref.watch(roomProgressListProvider(inspectionId));
    return AsyncView(
      value: inspectionValue,
      builder: (inspection) {
        if (inspection == null) return const Scaffold(body: SizedBox.shrink());
        final editable = inspection.status == InspectionStatus.inProgress;
        return Scaffold(
          appBar: AppBar(
            title: Text('${inspectionTypeLabel(inspection.type)} inspection'),
            actions: [
              PopupMenuButton<String>(
                tooltip: 'More options',
                onSelected: (v) => _menu(context, ref, v, inspection),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'notes',
                    child: Text('Inspection notes'),
                  ),
                  const PopupMenuItem(
                    value: 'verify',
                    child: Text('Check stored files'),
                  ),
                  if (!editable)
                    const PopupMenuItem(
                      value: 'reopen',
                      child: Text('Reopen inspection'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete inspection'),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: editable
                  ? FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ReviewScreen(inspectionId: inspectionId),
                        ),
                      ),
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('Review & finish'),
                    )
                  : FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ReportScreen(inspectionId: inspectionId),
                        ),
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('Report & share'),
                    ),
            ),
          ),
          body: AsyncView(
            value: roomsValue,
            builder: (rooms) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _ProgressHeader(inspection: inspection, rooms: rooms),
                if (inspection.baselineInspectionId != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.compare_outlined),
                      title: const Text('Compare with baseline'),
                      subtitle: const Text(
                        'View rooms side by side with the earlier inspection',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ComparisonScreen(inspectionId: inspectionId),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (rooms.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No rooms yet. Add the rooms you want to document.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                for (final r in rooms) ...[
                  _RoomTile(progress: r, editable: editable),
                  const SizedBox(height: 8),
                ],
                if (editable)
                  OutlinedButton.icon(
                    onPressed: () => _addRoom(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add room'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.inspection, required this.rooms});

  final Inspection inspection;
  final List<RoomProgress> rooms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = rooms
        .where((r) => r.room.status == RoomStatus.completed)
        .length;
    final media = rooms.fold<int>(0, (a, r) => a + r.mediaCount);
    final issues = rooms.fold<int>(0, (a, r) => a + r.issueCount);
    final fraction = rooms.isEmpty ? 0.0 : done / rooms.length;
    final completed = inspection.status == InspectionStatus.completed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          completed
              ? 'Finished ${dateTimeFormat.format(inspection.completedAt!)}'
              : 'Started ${dateTimeFormat.format(inspection.startedAt)}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Semantics(
          label: '$done of ${rooms.length} rooms done',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$done of ${rooms.length} rooms done',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: fraction,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$media photos/videos · $issues issues',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _RoomTile extends ConsumerWidget {
  const _RoomTile({required this.progress, required this.editable});

  final RoomProgress progress;
  final bool editable;

  Future<void> _menu(BuildContext context, WidgetRef ref, String v) async {
    final repo = ref.read(inspectionRepositoryProvider);
    final room = progress.room;
    if (v == 'rename') {
      final name = await promptText(
        context,
        title: 'Rename room',
        initial: room.name,
      );
      if (name != null && context.mounted) {
        await runGuarded(context, () => repo.renameRoom(room.id, name));
      }
    } else if (v == 'delete') {
      final ok = await confirmAction(
        context,
        title: 'Delete "${room.name}"?',
        message: progress.mediaCount == 0
            ? 'The room and its prompts will be removed.'
            : 'The room and its ${progress.mediaCount} photos/videos will be '
                  'permanently deleted.',
        confirmLabel: 'Delete',
        destructive: true,
      );
      if (ok && context.mounted) {
        await runGuarded(context, () => repo.deleteRoom(room.id));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final room = progress.room;
    final (IconData icon, String label, Color color) = switch (room.status) {
      RoomStatus.completed => (
        Icons.check_circle_outline,
        'Done',
        StatusColors.done(scheme),
      ),
      RoomStatus.inProgress => (
        Icons.timelapse,
        'In progress',
        StatusColors.warning(scheme),
      ),
      RoomStatus.notStarted => (
        Icons.radio_button_unchecked,
        'Not started',
        StatusColors.pending(scheme),
      ),
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => RoomScreen(roomId: room.id))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progress.doneCount} of ${progress.totalCount} prompts'
                      ' · ${progress.mediaCount} media'
                      '${progress.issueCount > 0 ? ' · ${progress.issueCount} issues' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    StatusLabel(icon: icon, label: label, color: color),
                  ],
                ),
              ),
              if (editable)
                PopupMenuButton<String>(
                  tooltip: 'Room options for ${room.name}',
                  onSelected: (v) => _menu(context, ref, v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'rename', child: Text('Rename')),
                    PopupMenuItem(value: 'delete', child: Text('Delete room')),
                  ],
                )
              else
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: ExcludeSemantics(child: Icon(Icons.chevron_right)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
