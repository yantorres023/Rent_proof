import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../../report/snapshot_loader.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'media_screen.dart';

class ComparisonData {
  const ComparisonData({required this.baseline, required this.pairs});

  final InspectionSnapshot baseline;
  final List<RoomPair> pairs;
}

final comparisonDataProvider = FutureProvider.autoDispose
    .family<ComparisonData?, String>((ref, inspectionId) async {
      // Rebuild when evidence changes.
      ref.watch(roomProgressListProvider(inspectionId));
      final loader = SnapshotLoader(
        ref.watch(databaseProvider),
        ref.watch(storagePathsProvider),
      );
      final current = await loader.load(inspectionId);
      final baselineId = current.inspection.baselineInspectionId;
      if (baselineId == null) return null;
      final exists = await ref
          .read(inspectionRepositoryProvider)
          .watchInspection(baselineId)
          .first;
      if (exists == null) return null;
      final baseline = await loader.load(baselineId);
      return ComparisonData(
        baseline: baseline,
        pairs: pairRooms(current, baseline),
      );
    });

/// Manual, side-by-side comparison. The app does not detect damage itself.
class ComparisonScreen extends ConsumerWidget {
  const ComparisonScreen({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(comparisonDataProvider(inspectionId));
    return Scaffold(
      appBar: AppBar(title: const Text('Compare rooms')),
      body: AsyncView(
        value: data,
        builder: (d) {
          if (d == null) {
            return const EmptyState(
              icon: Icons.compare_outlined,
              title: 'No baseline',
              message:
                  'The earlier inspection used for comparison was deleted.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Baseline: ${inspectionTypeLabel(d.baseline.inspection.type)} '
                'inspection, ${dateFormat.format(d.baseline.inspection.startedAt)}',
              ),
              const SizedBox(height: 4),
              Text(
                'Look at each room side by side and record what you see. '
                'The app does not detect changes automatically.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              for (final pair in d.pairs)
                _PairTile(pair: pair, inspectionId: inspectionId),
            ],
          );
        },
      ),
    );
  }
}

class _PairTile extends ConsumerWidget {
  const _PairTile({required this.pair, required this.inspectionId});

  final RoomPair pair;
  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = pair.current;
    final verdict = current == null
        ? null
        : ref.watch(comparisonProvider(current.room.id)).value?.verdict;
    final scheme = Theme.of(context).colorScheme;
    final subtitle = current == null
        ? 'Only in the baseline'
        : pair.baseline == null
        ? 'New room (not in baseline)'
        : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(pair.name),
        subtitle: subtitle != null
            ? Text(subtitle)
            : StatusLabel(
                icon:
                    verdict == null || verdict == ComparisonVerdict.notReviewed
                    ? Icons.radio_button_unchecked
                    : Icons.check_circle_outline,
                label: verdictLabel(verdict ?? ComparisonVerdict.notReviewed),
                color:
                    verdict == null || verdict == ComparisonVerdict.notReviewed
                    ? StatusColors.pending(scheme)
                    : StatusColors.done(scheme),
              ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RoomComparisonScreen(pair: pair)),
        ),
      ),
    );
  }
}

class RoomComparisonScreen extends ConsumerStatefulWidget {
  const RoomComparisonScreen({super.key, required this.pair});

  final RoomPair pair;

  @override
  ConsumerState<RoomComparisonScreen> createState() =>
      _RoomComparisonScreenState();
}

class _RoomComparisonScreenState extends ConsumerState<RoomComparisonScreen> {
  @override
  Widget build(BuildContext context) {
    final pair = widget.pair;
    final current = pair.current;
    final comparison = current == null
        ? null
        : ref.watch(comparisonProvider(current.room.id)).value;
    final verdict = comparison?.verdict ?? ComparisonVerdict.notReviewed;
    final labels = <String>{
      ...?pair.baseline?.checklist.map((c) => c.label),
      ...?current?.checklist.map((c) => c.label),
      if ((pair.baseline?.media.any((m) => m.promptLabel == null) ?? false) ||
          (current?.media.any((m) => m.promptLabel == null) ?? false))
        '',
    };
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(pair.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Baseline', style: theme.textTheme.titleSmall),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text('Now', style: theme.textTheme.titleSmall)),
            ],
          ),
          for (final label in labels) ...[
            const SizedBox(height: 12),
            Text(
              label.isEmpty ? 'Other photos' : label,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Strip(
                    entries: _media(pair.baseline, label),
                    side: 'Baseline',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Strip(entries: _media(current, label), side: 'Now'),
                ),
              ],
            ),
          ],
          const Divider(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _IssueList(
                  title: 'Baseline issues',
                  room: pair.baseline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _IssueList(title: 'Issues now', room: current),
              ),
            ],
          ),
          if (current != null) ...[
            const Divider(height: 32),
            Semantics(
              header: true,
              child: Text(
                'Your comparison',
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<ComparisonVerdict>(
              groupValue: verdict,
              onChanged: (v) => runGuarded(
                context,
                () => ref
                    .read(inspectionRepositoryProvider)
                    .setComparisonVerdict(
                      current.room.id,
                      v!,
                      note: comparison?.note ?? '',
                    ),
              ),
              child: Column(
                children: [
                  for (final v in ComparisonVerdict.values)
                    RadioListTile<ComparisonVerdict>(
                      value: v,
                      title: Text(verdictLabel(v)),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notes),
              title: Text(
                (comparison?.note ?? '').isEmpty
                    ? 'Add a note'
                    : comparison!.note,
              ),
              onTap: () async {
                final note = await promptText(
                  context,
                  title: 'Comparison note',
                  initial: comparison?.note ?? '',
                  maxLength: 2000,
                  maxLines: 5,
                );
                if (note != null && context.mounted) {
                  await runGuarded(
                    context,
                    () => ref
                        .read(inspectionRepositoryProvider)
                        .setComparisonVerdict(
                          current.room.id,
                          verdict,
                          note: note,
                        ),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  List<MediaEntry> _media(RoomEntry? room, String label) => [
    if (room != null)
      for (final m in room.media)
        if ((m.promptLabel ?? '') == label) m,
  ];
}

class _Strip extends StatelessWidget {
  const _Strip({required this.entries, required this.side});

  final List<MediaEntry> entries;
  final String side;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('No photo'),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MediaScreen(mediaId: entries[i].media.id),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, c) => FileThumb(
                  path: entries[i].thumbnailFile,
                  isVideo: entries[i].media.kind == MediaKind.video,
                  size: c.maxWidth,
                  semanticLabel:
                      '$side ${entries[i].media.kind.name} ${i + 1}, '
                      '${dateFormat.format(entries[i].media.recordedAt)}',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _IssueList extends StatelessWidget {
  const _IssueList({required this.title, required this.room});

  final String title;
  final RoomEntry? room;

  @override
  Widget build(BuildContext context) {
    final issues = room?.issues ?? const <Issue>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        if (issues.isEmpty) const Text('None recorded'),
        for (final i in issues)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• ${i.title} (${severityLabel(i.severity)})'),
          ),
      ],
    );
  }
}
