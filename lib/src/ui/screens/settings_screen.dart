import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_info.dart';
import '../../providers.dart';
import '../../report/pdf_report_builder.dart' show reportLimitations;
import '../../report/report_models.dart' show formatBytes;
import '../widgets/common.dart';

final _storageUsedProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(settingsRepositoryProvider).storageUsedBytes(),
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _editProfile(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(profileProvider).value;
    final name = await promptText(
      context,
      title: 'Your name on reports',
      initial: profile?.displayName ?? '',
      label: 'Shown as "Prepared by" (optional)',
    );
    if (name == null || !context.mounted) return;
    await runGuarded(
      context,
      () => ref
          .read(settingsRepositoryProvider)
          .saveProfile(name: name, email: profile?.email ?? ''),
    );
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final ok = await confirmAction(
      context,
      title: 'Delete all data?',
      message:
          'Every place, inspection, photo, video, report and setting stored '
          'by this app on this phone will be permanently erased. Export '
          'evidence packages first if you need them. This cannot be undone.',
      confirmLabel: 'Continue',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final typed = await promptText(
      context,
      title: 'Type DELETE to confirm',
      confirmLabel: 'Erase everything',
    );
    if (typed?.trim().toUpperCase() != 'DELETE' || !context.mounted) return;
    final navigator = Navigator.of(context);
    final done = await runGuarded(context, () async {
      await ref.read(settingsRepositoryProvider).deleteAllData();
      return true;
    });
    if (done == true) navigator.popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final used = ref.watch(_storageUsedProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Your name on reports'),
            subtitle: Text(
              (profile?.displayName ?? '').isEmpty
                  ? 'Not set'
                  : profile!.displayName,
            ),
            onTap: () => _editProfile(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.sd_storage_outlined),
            title: const Text('Storage used by evidence and reports'),
            subtitle: Text(
              used.when(
                data: formatBytes,
                loading: () => 'Calculating…',
                error: (_, _) => 'Unavailable',
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Semantics(
              header: true,
              child: Text(
                'What this app can and cannot show',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          for (final line in reportLimitations)
            ListTile(
              dense: true,
              leading: const Icon(Icons.info_outline, size: 20),
              title: Text(line),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Semantics(
              header: true,
              child: Text('Privacy', style: theme.textTheme.titleMedium),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'No account, no analytics, no ads, no crash reporting. Your '
              'places, photos, notes and reports are stored in this app\'s '
              'private storage on this phone and are sent nowhere unless you '
              'share or export them. Your phone\'s own backup service may '
              'include app data depending on your settings. Uninstalling the '
              'app deletes everything.',
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: theme.colorScheme.error,
            ),
            title: Text(
              'Delete all data',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _deleteAll(context, ref),
          ),
          const Divider(),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: appName,
            applicationVersion: appVersion,
            aboutBoxChildren: const [
              Text(
                'A tool for renters to keep an organized record of a home\'s '
                'condition. Not legal advice.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
