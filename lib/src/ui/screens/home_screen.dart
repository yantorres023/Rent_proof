import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_info.dart';
import '../../data/property_repository.dart';
import '../../providers.dart';
import '../capture.dart';
import '../widgets/common.dart';
import 'property_form_screen.dart';
import 'property_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) recoverLostCaptures(context, ref);
    });
  }

  Future<void> _addPlace(BuildContext context) async {
    final created = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const PropertyFormScreen()),
    );
    if (created != null && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PropertyScreen(propertyId: created)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(propertySummariesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      floatingActionButton: summaries.maybeWhen(
        data: (list) => list.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _addPlace(context),
                icon: const Icon(Icons.add_home_outlined),
                label: const Text('Add place'),
              ),
        orElse: () => null,
      ),
      body: AsyncView(
        value: summaries,
        builder: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.home_work_outlined,
              title: 'Start with your place',
              message:
                  'Add the home you are moving into. Then walk through it '
                  'room by room and create a dated condition report.',
              action: FilledButton.icon(
                onPressed: () => _addPlace(context),
                icon: const Icon(Icons.add_home_outlined),
                label: const Text('Add your place'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _PropertyCard(summary: list[i]),
          );
        },
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.summary});

  final PropertySummary summary;

  @override
  Widget build(BuildContext context) {
    final p = summary.property;
    final theme = Theme.of(context);
    final address = [
      p.addressLine1,
      p.city,
    ].where((s) => s.isNotEmpty).join(', ');
    final count = summary.inspectionCount;
    final subtitle = count == 0
        ? 'No inspections yet'
        : '$count inspection${count == 1 ? '' : 's'} · last '
              '${dateFormat.format(summary.lastInspectionAt!)}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PropertyScreen(propertyId: p.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.home_outlined,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.nickname,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (address.isNotEmpty)
                      Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const ExcludeSemantics(child: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      ),
    );
  }
}
