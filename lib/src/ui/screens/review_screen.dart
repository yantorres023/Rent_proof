import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'report_screen.dart';
import 'room_screen.dart';

/// Last check before finishing: shows gaps honestly, never blocks on them
/// (except that at least one photo/video is required).
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _finishing = false;

  Future<void> _finish() async {
    setState(() => _finishing = true);
    final navigator = Navigator.of(context);
    final ok = await runGuarded(context, () async {
      await ref
          .read(inspectionRepositoryProvider)
          .complete(widget.inspectionId);
      return true;
    });
    if (!mounted) return;
    setState(() => _finishing = false);
    if (ok == true) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReportScreen(
            inspectionId: widget.inspectionId,
            generateOnOpen: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsValue = ref.watch(roomProgressListProvider(widget.inspectionId));
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Review & finish')),
      body: AsyncView(
        value: roomsValue,
        builder: (rooms) {
          final media = rooms.fold<int>(0, (a, r) => a + r.mediaCount);
          final issues = rooms.fold<int>(0, (a, r) => a + r.issueCount);
          final gaps = rooms.where((r) => r.doneCount < r.totalCount).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${rooms.length} rooms · $media photos/videos · $issues issues',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (media == 0)
                StatusLabel(
                  icon: Icons.error_outline,
                  label: 'Add at least one photo or video before finishing.',
                  color: scheme.error,
                )
              else if (gaps.isEmpty)
                StatusLabel(
                  icon: Icons.check_circle_outline,
                  label: 'Every prompt is documented or marked not applicable.',
                  color: StatusColors.done(scheme),
                )
              else ...[
                StatusLabel(
                  icon: Icons.warning_amber_outlined,
                  label: 'Some prompts have no photo yet',
                  color: StatusColors.warning(scheme),
                ),
                const SizedBox(height: 4),
                const Text(
                  'You can still finish. The report will show which prompts '
                  'were not documented.',
                ),
                const SizedBox(height: 8),
                for (final r in gaps)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      title: Text(r.room.name),
                      subtitle: Text(
                        'Missing: ${r.checklist.where((c) => !c.isDone).map((c) => c.item.label).join(', ')}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RoomScreen(roomId: r.room.id),
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              const Text(
                'After finishing, photos cannot be added or deleted unless '
                'you reopen the inspection. Next, you will create a PDF '
                'report you can send to your landlord.',
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: media == 0 || _finishing ? null : _finish,
                icon: const Icon(Icons.done_all),
                label: const Text('Finish & create report'),
              ),
            ],
          );
        },
      ),
    );
  }
}
