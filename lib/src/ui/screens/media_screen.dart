import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'issue_form_screen.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key, required this.mediaId});

  final String mediaId;

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  bool _placing = false;
  bool _checking = false;

  Future<void> _placeMarker(MediaItem media, Offset normalized) async {
    setState(() => _placing = false);
    final issues = await ref
        .read(evidenceRepositoryProvider)
        .roomIssues(media.roomId);
    if (!mounted) return;
    final result = await showDialog<({String label, String? issueId})>(
      context: context,
      builder: (context) => _MarkerDialog(issues: issues),
    );
    if (result == null || !mounted) return;
    await runGuarded(
      context,
      () => ref
          .read(evidenceRepositoryProvider)
          .addAnnotation(
            mediaId: media.id,
            x: normalized.dx,
            y: normalized.dy,
            label: result.label,
            issueId: result.issueId,
          ),
    );
  }

  Future<void> _verify() async {
    setState(() => _checking = true);
    final result = await runGuarded(
      context,
      () => ref.read(evidenceRepositoryProvider).verifyMedia(widget.mediaId),
    );
    if (!mounted) return;
    setState(() => _checking = false);
    if (result != null) {
      showMessage(context, switch (result) {
        HashCheckResult.match => 'Stored file matches its fingerprint.',
        HashCheckResult.mismatch =>
          'Stored file does NOT match its recorded fingerprint.',
        HashCheckResult.missing => 'Stored file is missing.',
        HashCheckResult.recorded => '',
      });
    }
  }

  Future<void> _delete(MediaItem media) async {
    final ok = await confirmAction(
      context,
      title: 'Delete this ${media.kind.name}?',
      message:
          'The original file and its fingerprint record will be permanently '
          'deleted. Issues that referred to it are kept.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final navigator = Navigator.of(context);
    final done = await runGuarded(context, () async {
      await ref.read(evidenceRepositoryProvider).deleteMedia(media.id);
      return true;
    });
    if (done == true) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaValue = ref.watch(mediaProvider(widget.mediaId));
    return AsyncView(
      value: mediaValue,
      builder: (media) {
        if (media == null) return const Scaffold(body: SizedBox.shrink());
        final room = ref.watch(roomProvider(media.roomId)).value;
        final inspection = room == null
            ? null
            : ref.watch(inspectionProvider(room.room.inspectionId)).value;
        final editable = inspection?.status == InspectionStatus.inProgress;
        final annotations =
            ref.watch(annotationsProvider(media.id)).value ?? const [];
        final history =
            ref.watch(hashHistoryProvider(media.id)).value ?? const [];
        final issues =
            ref.watch(roomIssuesProvider(media.roomId)).value ?? const [];
        final evidence = ref.read(evidenceRepositoryProvider);
        final previewPath = evidence.previewFilePath(media);
        final isPhoto = media.kind == MediaKind.photo;
        final prompts = room?.checklist ?? const [];
        return Scaffold(
          appBar: AppBar(
            title: Text(isPhoto ? 'Photo details' : 'Video details'),
            actions: [
              if (editable)
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(media),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              if (isPhoto && previewPath != null)
                _AnnotatedImage(
                  path: previewPath,
                  aspect: (media.width != null && media.height != null)
                      ? media.width! / media.height!
                      : 4 / 3,
                  annotations: annotations,
                  placing: _placing,
                  onPlace: (o) => _placeMarker(media, o),
                )
              else
                Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    isPhoto
                        ? 'A preview could not be made for this file format. '
                              'The original is stored unchanged and included '
                              'in the evidence package.'
                        : 'Video playback is not available in the app yet. '
                              'The original video is stored unchanged and '
                              'included in the evidence package.',
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (editable && isPhoto && previewPath != null)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                setState(() => _placing = !_placing),
                            icon: Icon(
                              _placing
                                  ? Icons.close
                                  : Icons.add_location_alt_outlined,
                            ),
                            label: Text(
                              _placing ? 'Cancel marking' : 'Mark a spot',
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => IssueFormScreen(
                                  roomId: media.roomId,
                                  initialMediaId: media.id,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.report_outlined),
                            label: const Text('Add issue'),
                          ),
                        ],
                      ),
                    if (_placing)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Tap the photo where the problem is.'),
                      ),
                    if (annotations.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionTitle('Markers (your notes)'),
                      for (var i = 0; i < annotations.length; i++)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: StatusColors.warning(
                              Theme.of(context).colorScheme,
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(_markerText(annotations[i], issues)),
                          trailing: editable
                              ? IconButton(
                                  tooltip: 'Remove marker ${i + 1}',
                                  icon: const Icon(Icons.close),
                                  onPressed: () => runGuarded(
                                    context,
                                    () => evidence.deleteAnnotation(
                                      annotations[i].id,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                    ],
                    const SizedBox(height: 16),
                    _SectionTitle('Your note'),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        media.caption.isEmpty ? 'No note' : media.caption,
                      ),
                      trailing: editable
                          ? const Icon(Icons.edit_outlined)
                          : null,
                      onTap: editable
                          ? () async {
                              final v = await promptText(
                                context,
                                title: 'Note',
                                initial: media.caption,
                                maxLength: 500,
                                maxLines: 4,
                              );
                              if (v != null && context.mounted) {
                                await runGuarded(
                                  context,
                                  () => evidence.updateCaption(media.id, v),
                                );
                              }
                            }
                          : null,
                    ),
                    if (editable && prompts.isNotEmpty)
                      DropdownButtonFormField<String?>(
                        initialValue:
                            prompts.any(
                              (c) => c.item.id == media.checklistItemId,
                            )
                            ? media.checklistItemId
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Prompt'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Other'),
                          ),
                          for (final c in prompts)
                            DropdownMenuItem(
                              value: c.item.id,
                              child: Text(c.item.label),
                            ),
                        ],
                        onChanged: (v) => runGuarded(
                          context,
                          () => evidence.assignChecklistItem(media.id, v),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _SectionTitle('Recorded by the app'),
                    _Meta('Saved', dateTimeFormat.format(media.recordedAt)),
                    _Meta(
                      'How',
                      media.source == MediaSource.camera
                          ? 'Taken with the camera from the app'
                          : 'Imported from your photos',
                    ),
                    _Meta('File size', formatBytes(media.byteSize)),
                    if (media.width != null)
                      _Meta('Dimensions', '${media.width} × ${media.height}'),
                    _HashRow(hash: media.sha256),
                    const SizedBox(height: 12),
                    _SectionTitle('From the file (not verified)'),
                    _Meta(
                      'Camera date',
                      media.exifDateTimeOriginal ?? 'Not present',
                    ),
                    if (media.exifMake != null || media.exifModel != null)
                      _Meta(
                        'Device',
                        [
                          media.exifMake,
                          media.exifModel,
                        ].whereType<String>().join(' '),
                      ),
                    if (media.originalHasGps)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'The original file contains location (GPS) data. '
                          'It is not shown in reports, but it is inside the '
                          'original if you export the evidence package.',
                        ),
                      ),
                    const SizedBox(height: 12),
                    _SectionTitle('File checks'),
                    for (final h in history)
                      _Meta(
                        dateTimeFormat.format(h.computedAt),
                        switch (h.result) {
                          HashCheckResult.recorded => 'Fingerprint recorded',
                          HashCheckResult.match => 'Matches ✓',
                          HashCheckResult.mismatch => 'Does not match ✗',
                          HashCheckResult.missing => 'File missing ✗',
                        },
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _checking ? null : _verify,
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Check file now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _markerText(Annotation a, List<Issue> issues) {
  if (a.label.isNotEmpty) return a.label;
  final issue = issues.where((i) => i.id == a.issueId).firstOrNull;
  return issue?.title ?? 'Marked area';
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

class _Meta extends StatelessWidget {
  const _Meta(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    ),
  );
}

class _HashRow extends StatelessWidget {
  const _HashRow({required this.hash});

  final String hash;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            'SHA-256',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            hash,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        IconButton(
          tooltip: 'Copy fingerprint',
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: hash));
            showMessage(context, 'Fingerprint copied');
          },
        ),
      ],
    );
  }
}

class _AnnotatedImage extends StatelessWidget {
  const _AnnotatedImage({
    required this.path,
    required this.aspect,
    required this.annotations,
    required this.placing,
    required this.onPlace,
  });

  final String path;
  final double aspect;
  final List<Annotation> annotations;
  final bool placing;
  final ValueChanged<Offset> onPlace;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.55;
    return LayoutBuilder(
      builder: (context, constraints) {
        var w = constraints.maxWidth;
        var h = w / aspect;
        if (h > maxHeight) {
          h = maxHeight;
          w = h * aspect;
        }
        return Center(
          child: SizedBox(
            width: w,
            height: h,
            child: GestureDetector(
              onTapUp: placing
                  ? (d) => onPlace(
                      Offset(d.localPosition.dx / w, d.localPosition.dy / h),
                    )
                  : null,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Semantics(
                      image: true,
                      label: placing
                          ? 'Photo. Tap where the problem is to place a marker'
                          : 'Photo with ${annotations.length} markers',
                      child: Image.file(
                        File(path),
                        fit: BoxFit.fill,
                        cacheWidth: (w * MediaQuery.devicePixelRatioOf(context))
                            .round(),
                        errorBuilder: (_, _, _) => const Center(
                          child: Icon(Icons.broken_image_outlined, size: 48),
                        ),
                      ),
                    ),
                  ),
                  for (var i = 0; i < annotations.length; i++)
                    Positioned(
                      left: annotations[i].x * w - 14,
                      top: annotations[i].y * h - 14,
                      child: ExcludeSemantics(
                        child: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: StatusColors.warning(
                              Theme.of(context).colorScheme,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (placing)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MarkerDialog extends StatefulWidget {
  const _MarkerDialog({required this.issues});

  final List<Issue> issues;

  @override
  State<_MarkerDialog> createState() => _MarkerDialogState();
}

class _MarkerDialogState extends State<_MarkerDialog> {
  final _label = TextEditingController();
  String? _issueId;

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Marker'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _label,
            autofocus: true,
            maxLength: 60,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Label (optional)',
              hintText: 'e.g. Chip in tile',
            ),
          ),
          if (widget.issues.isNotEmpty)
            DropdownButtonFormField<String?>(
              initialValue: _issueId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Link to issue'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                for (final i in widget.issues)
                  DropdownMenuItem(value: i.id, child: Text(i.title)),
              ],
              onChanged: (v) => setState(() => _issueId = v),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, (label: _label.text, issueId: _issueId)),
          child: const Text('Add marker'),
        ),
      ],
    );
  }
}
