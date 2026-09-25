import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../report/report_models.dart';
import '../../services/share_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    super.key,
    required this.inspectionId,
    this.generateOnOpen = false,
  });

  final String inspectionId;
  final bool generateOnOpen;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  String? _busy;

  @override
  void initState() {
    super.initState();
    if (widget.generateOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
    }
  }

  Future<T?> _run<T>(String label, Future<T> Function() action) async {
    setState(() => _busy = label);
    try {
      return await runGuarded(context, action);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _generate() async {
    final report = await _run(
      'Creating report…',
      () => ref.read(reportRepositoryProvider).generate(widget.inspectionId),
    );
    if (report != null && mounted) showMessage(context, 'Report created');
  }

  Future<void> _share(Report report, {required bool toLandlord}) async {
    final repo = ref.read(reportRepositoryProvider);
    final property = await _propertyName();
    final file = await _run('Preparing…', () => repo.exportReport(report));
    if (file == null || !mounted) return;
    final outcome = await _run(
      'Opening share…',
      () => ref
          .read(shareServiceProvider)
          .shareFiles(
            [file.path],
            subject: toLandlord
                ? 'Move-in condition report – $property'
                : 'Condition report – $property',
            text: toLandlord
                ? 'Hello,\n\nAttached is my condition report for $property, '
                      'created on ${dateTimeFormat.format(report.generatedAt)}. '
                      'Please keep it with my tenancy records and let me know '
                      'if you see anything differently.\n\n'
                      'Report fingerprint (SHA-256): ${report.sha256}\n'
                : null,
          ),
    );
    if (!toLandlord || !mounted || outcome == ShareOutcome.dismissed) return;
    final sent = await confirmAction(
      context,
      title: 'Did you send it?',
      message:
          'If you sent the report to your landlord or manager, the app will '
          'note today\'s date. Keep the sent email or message: it is your '
          'best record of when they received it.',
      confirmLabel: 'Yes, I sent it',
    );
    if (sent && mounted) {
      await runGuarded(context, () => repo.markSent(report.id, sent: true));
    }
  }

  Future<String> _propertyName() async {
    final inspection = await ref
        .read(inspectionRepositoryProvider)
        .getInspection(widget.inspectionId);
    final p = await ref
        .read(propertyRepositoryProvider)
        .get(inspection.propertyId);
    return p.nickname;
  }

  Future<void> _exportPackage(Report? latest) async {
    final repo = ref.read(reportRepositoryProvider);
    final zip = await _run(
      'Building evidence package…',
      () => repo.exportEvidencePackage(widget.inspectionId, report: latest),
    );
    if (zip == null || !mounted) return;
    final outcome = await _run(
      'Opening share…',
      () => ref.read(shareServiceProvider).shareFiles([
        zip.path,
      ], subject: 'Evidence package'),
    );
    if (outcome != null && outcome != ShareOutcome.dismissed && mounted) {
      await runGuarded(
        context,
        () => repo.markPackageExported(widget.inspectionId),
      );
    }
  }

  Future<void> _delete(Report report) async {
    final ok = await confirmAction(
      context,
      title: 'Delete this report?',
      message:
          'The PDF will be removed from this phone. Copies you already '
          'shared are not affected. Photos are kept.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (ok && mounted) {
      await runGuarded(
        context,
        () => ref.read(reportRepositoryProvider).deleteReport(report.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsValue = ref.watch(reportsProvider(widget.inspectionId));
    final inspection = ref.watch(inspectionProvider(widget.inspectionId)).value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report & share'),
        bottom: _busy == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(semanticsLabel: _busy),
              ),
      ),
      body: AsyncView(
        value: reportsValue,
        builder: (reports) {
          final latest = reports.firstOrNull;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_busy != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_busy!, style: theme.textTheme.titleMedium),
                ),
              if (latest == null)
                EmptyState(
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'No report yet',
                  message:
                      'Create a PDF with every room, photo, issue and note.',
                  action: FilledButton.icon(
                    onPressed: _busy == null ? _generate : null,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Create report'),
                  ),
                )
              else ...[
                _ReportCard(
                  report: latest,
                  busy: _busy != null,
                  onShare: () => _share(latest, toLandlord: false),
                  onSendToLandlord: () => _share(latest, toLandlord: true),
                  onDelete: () => _delete(latest),
                ),
                const SizedBox(height: 12),
                if (inspection?.type == InspectionType.moveIn)
                  const _DeadlineNote(),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busy == null ? _generate : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Create a new version'),
                ),
              ],
              const SizedBox(height: 24),
              Semantics(
                header: true,
                child: Text(
                  'Keep a backup',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your photos live only on this phone. Export the evidence '
                'package (a .zip with every original file, the report and a '
                'list of fingerprints) and save it somewhere safe, like your '
                'email or cloud storage, so it survives a lost or replaced '
                'phone. Original photos may include location data written '
                'by your camera.',
              ),
              const SizedBox(height: 8),
              StatusLabel(
                icon: inspection?.lastPackageExportAt != null
                    ? Icons.cloud_done_outlined
                    : Icons.warning_amber_outlined,
                label: inspection?.lastPackageExportAt != null
                    ? 'Backup exported on '
                          '${dateFormat.format(inspection!.lastPackageExportAt!)}'
                    : 'No backup exported yet',
                color: inspection?.lastPackageExportAt != null
                    ? StatusColors.done(theme.colorScheme)
                    : StatusColors.warning(theme.colorScheme),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy == null ? () => _exportPackage(latest) : null,
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Export evidence package'),
              ),
              if (reports.length > 1) ...[
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(
                    'Earlier versions',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                for (final r in reports.skip(1))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(dateTimeFormat.format(r.generatedAt)),
                    subtitle: Text(
                      '${formatBytes(r.byteSize)} · ${count(r.mediaCount, 'photo/video', 'photos/videos')}'
                      '${r.sentToLandlordAt != null ? ' · marked sent' : ''}',
                    ),
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Options for this version',
                      onSelected: (v) => v == 'share'
                          ? _share(r, toLandlord: false)
                          : _delete(r),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'share', child: Text('Share')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({
    required this.report,
    required this.busy,
    required this.onShare,
    required this.onSendToLandlord,
    required this.onDelete,
  });

  final Report report;
  final bool busy;
  final VoidCallback onShare;
  final VoidCallback onSendToLandlord;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sent = report.sentToLandlordAt;
    final exists = File(
      ref.read(reportRepositoryProvider).reportFilePath(report),
    ).existsSync();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const ExcludeSemantics(
                  child: Icon(Icons.picture_as_pdf_outlined, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latest report', style: theme.textTheme.titleMedium),
                      Text(dateTimeFormat.format(report.generatedAt)),
                      Text(
                        '${formatBytes(report.byteSize)} · '
                        '${count(report.mediaCount, 'photo/video', 'photos/videos')} · '
                        '${count(report.issueCount, 'issue')}'
                        '${report.includesComparison ? ' · with comparison' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Delete report',
                  onPressed: busy ? null : onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!exists)
              Text(
                'The PDF file is missing. Create a new version.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            StatusLabel(
              icon: sent != null
                  ? Icons.mark_email_read_outlined
                  : Icons.outgoing_mail,
              label: sent != null
                  ? 'You marked this as sent on ${dateFormat.format(sent)}'
                  : 'Not sent to your landlord yet',
              color: sent != null
                  ? StatusColors.done(theme.colorScheme)
                  : StatusColors.warning(theme.colorScheme),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: busy || !exists ? null : onSendToLandlord,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Send to landlord'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: busy || !exists ? null : onShare,
              icon: const Icon(Icons.ios_share),
              label: const Text('Share or save PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineNote extends StatelessWidget {
  const _DeadlineNote();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Your lease or local rules may set a deadline (sometimes only a few '
        'days) for recording move-in condition or returning a checklist. '
        'Check your lease. Sending by email keeps a dated copy for both of '
        'you. This app does not give legal advice.',
        style: TextStyle(color: scheme.onSecondaryContainer),
      ),
    );
  }
}
