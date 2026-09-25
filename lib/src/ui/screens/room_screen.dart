import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/inspection_repository.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../capture.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'issue_form_screen.dart';
import 'media_screen.dart';

class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  bool _busy = false;

  Future<void> _capture(String? itemId, CaptureAction action) => runCapture(
    context,
    ref,
    roomId: widget.roomId,
    checklistItemId: itemId,
    action: action,
    onBusy: (b) {
      if (mounted) setState(() => _busy = b);
    },
  );

  Future<void> _finishRoom(Room room) async {
    final repo = ref.read(inspectionRepositoryProvider);
    final ok = await runGuarded(context, () async {
      await repo.setRoomStatus(room.id, RoomStatus.completed);
      return true;
    });
    if (ok != true || !mounted) return;
    final rooms = await repo.watchRoomProgress(room.inspectionId).first;
    if (!mounted) return;
    final next = rooms
        .where((r) => r.room.status != RoomStatus.completed)
        .map((r) => r.room)
        .where((r) => r.position > room.position)
        .firstOrNull;
    if (next != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RoomScreen(roomId: next.id)),
      );
    } else {
      Navigator.of(context).pop();
      showMessage(context, '"${room.name}" is done.');
    }
  }

  Future<void> _menu(String v, RoomProgress progress) async {
    final repo = ref.read(inspectionRepositoryProvider);
    final room = progress.room;
    switch (v) {
      case 'notes':
        final notes = await promptText(
          context,
          title: 'Notes for ${room.name}',
          initial: room.notes,
          maxLength: 4000,
          maxLines: 6,
        );
        if (notes != null && mounted) {
          await runGuarded(context, () => repo.updateRoomNotes(room.id, notes));
        }
      case 'prompt':
        final label = await promptText(
          context,
          title: 'Add a prompt',
          label: 'e.g. Ceiling fan, Balcony door',
          confirmLabel: 'Add',
        );
        if (label != null && label.trim().isNotEmpty && mounted) {
          await runGuarded(
            context,
            () => repo.addChecklistItem(room.id, label),
          );
        }
      case 'reopen':
        await runGuarded(
          context,
          () => repo.setRoomStatus(room.id, RoomStatus.inProgress),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomValue = ref.watch(roomProvider(widget.roomId));
    final mediaValue = ref.watch(roomMediaProvider(widget.roomId));
    final issuesValue = ref.watch(roomIssuesProvider(widget.roomId));
    return AsyncView(
      value: roomValue,
      builder: (progress) {
        if (progress == null) return const Scaffold(body: SizedBox.shrink());
        final room = progress.room;
        final inspection = ref
            .watch(inspectionProvider(room.inspectionId))
            .value;
        final editable = inspection?.status == InspectionStatus.inProgress;
        final media = mediaValue.value ?? const <MediaItem>[];
        final issues = issuesValue.value ?? const <Issue>[];
        final unassigned = media.where(
          (m) =>
              m.checklistItemId == null ||
              !progress.checklist.any((c) => c.item.id == m.checklistItemId),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(room.name, overflow: TextOverflow.ellipsis),
            actions: [
              if (editable)
                PopupMenuButton<String>(
                  tooltip: 'More options',
                  onSelected: (v) => _menu(v, progress),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'notes',
                      child: Text('Room notes'),
                    ),
                    const PopupMenuItem(
                      value: 'prompt',
                      child: Text('Add a prompt'),
                    ),
                    if (room.status == RoomStatus.completed)
                      const PopupMenuItem(
                        value: 'reopen',
                        child: Text('Mark as not done'),
                      ),
                  ],
                ),
            ],
            bottom: _busy
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(
                      semanticsLabel: 'Saving file',
                    ),
                  )
                : null,
          ),
          bottomNavigationBar: editable
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: room.status == RoomStatus.completed
                        ? OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.check),
                            label: const Text('Room done · back to rooms'),
                          )
                        : FilledButton.icon(
                            onPressed: _busy ? null : () => _finishRoom(room),
                            icon: const Icon(Icons.check),
                            label: Text(
                              progress.doneCount < progress.totalCount
                                  ? 'Done with room '
                                        '(${progress.doneCount}/${progress.totalCount})'
                                  : 'Done with room',
                            ),
                          ),
                  ),
                )
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (!editable)
                const _Banner(
                  icon: Icons.lock_outline,
                  text:
                      'This inspection is finished, so photos can no longer '
                      'be added or deleted here.',
                )
              else if (media.isEmpty)
                const _Banner(
                  icon: Icons.lightbulb_outline,
                  text:
                      'Take a photo for each prompt. For damage, take one '
                      'close-up and one from further away so the location is '
                      'clear.',
                ),
              if (room.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.notes),
                    title: const Text('Room notes'),
                    subtitle: Text(room.notes),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              for (final c in progress.checklist) ...[
                _PromptCard(
                  progress: c,
                  media: media
                      .where((m) => m.checklistItemId == c.item.id)
                      .toList(),
                  editable: editable && !_busy,
                  onCapture: (a) => _capture(c.item.id, a),
                ),
                const SizedBox(height: 8),
              ],
              if (unassigned.isNotEmpty || editable) ...[
                _PromptCard.other(
                  media: unassigned.toList(),
                  editable: editable && !_busy,
                  onCapture: (a) => _capture(null, a),
                ),
                const SizedBox(height: 16),
              ],
              _IssuesSection(
                roomId: room.id,
                issues: issues,
                media: media,
                editable: editable,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(icon, color: scheme.onSecondaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptCard extends ConsumerWidget {
  const _PromptCard({
    required ChecklistProgress this.progress,
    required this.media,
    required this.editable,
    required this.onCapture,
  });

  const _PromptCard.other({
    required this.media,
    required this.editable,
    required this.onCapture,
  }) : progress = null;

  final ChecklistProgress? progress;
  final List<MediaItem> media;
  final bool editable;
  final ValueChanged<CaptureAction> onCapture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final p = progress;
    final title = p?.item.label ?? 'Other photos';
    final na = p?.item.notApplicable ?? false;
    final (IconData icon, String status, Color color) = p == null
        ? (
            Icons.photo_library_outlined,
            '${media.length}',
            scheme.onSurfaceVariant,
          )
        : na
        ? (
            Icons.do_not_disturb_on_outlined,
            'Not applicable',
            StatusColors.pending(scheme),
          )
        : p.mediaCount > 0
        ? (
            Icons.check_circle,
            '${p.mediaCount} added',
            StatusColors.done(scheme),
          )
        : (
            Icons.radio_button_unchecked,
            'Not documented',
            StatusColors.pending(scheme),
          );
    final evidence = ref.read(evidenceRepositoryProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      StatusLabel(icon: icon, label: status, color: color),
                    ],
                  ),
                ),
                if (editable)
                  PopupMenuButton<String>(
                    tooltip: 'More ways to add for $title',
                    onSelected: (v) async {
                      switch (v) {
                        case 'import':
                          onCapture(CaptureAction.importPhotos);
                        case 'video':
                          onCapture(CaptureAction.video);
                        case 'importVideo':
                          onCapture(CaptureAction.importVideo);
                        case 'na':
                          await runGuarded(
                            context,
                            () => ref
                                .read(inspectionRepositoryProvider)
                                .setChecklistNotApplicable(p!.item.id, !na),
                          );
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'import',
                        child: Text('Import photos'),
                      ),
                      const PopupMenuItem(
                        value: 'video',
                        child: Text('Record video'),
                      ),
                      const PopupMenuItem(
                        value: 'importVideo',
                        child: Text('Import video'),
                      ),
                      if (p != null)
                        PopupMenuItem(
                          value: 'na',
                          child: Text(
                            na ? 'Mark as applicable' : 'Not in this unit',
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            if (media.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final m = media[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MediaScreen(mediaId: m.id),
                        ),
                      ),
                      child: FileThumb(
                        path: evidence.thumbnailFilePath(m),
                        isVideo: m.kind == MediaKind.video,
                        semanticLabel:
                            '${m.kind == MediaKind.video ? 'Video' : 'Photo'} '
                            '${i + 1} of $title, saved '
                            '${dateTimeFormat.format(m.recordedAt)}. '
                            'Open details',
                      ),
                    );
                  },
                ),
              ),
            ],
            if (editable && !na) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => onCapture(CaptureAction.photo),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(
                          media.isEmpty ? 'Take photo' : 'Add photo',
                          semanticsLabel: media.isEmpty
                              ? 'Take photo of $title'
                              : 'Add another photo of $title',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IssuesSection extends StatelessWidget {
  const _IssuesSection({
    required this.roomId,
    required this.issues,
    required this.media,
    required this.editable,
  });

  final String roomId;
  final List<Issue> issues;
  final List<MediaItem> media;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Issues (${issues.length})',
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 4),
        if (issues.isEmpty)
          const Text(
            'Record anything damaged, dirty, missing or not working, even if '
            'it seems small.',
          ),
        for (final issue in issues)
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              leading: const Icon(Icons.report_outlined),
              title: Text(issue.title),
              subtitle: Text(
                '${severityLabel(issue.severity)} · '
                '${issueCategoryLabel(issue.category)}'
                '${issue.mediaId != null ? ' · photo linked' : ''}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => IssueFormScreen(
                    roomId: roomId,
                    existing: issue,
                    readOnly: !editable,
                  ),
                ),
              ),
            ),
          ),
        if (editable) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => IssueFormScreen(roomId: roomId),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add issue'),
          ),
        ],
      ],
    );
  }
}
