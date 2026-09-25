import 'package:share_plus/share_plus.dart';

enum ShareOutcome { shared, dismissed, unavailable }

abstract interface class ShareService {
  Future<ShareOutcome> shareFiles(
    List<String> paths, {
    String? subject,
    String? text,
  });
}

class SystemShareService implements ShareService {
  const SystemShareService();

  @override
  Future<ShareOutcome> shareFiles(
    List<String> paths, {
    String? subject,
    String? text,
  }) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [for (final p in paths) XFile(p)],
        subject: subject,
        text: text,
      ),
    );
    return switch (result.status) {
      ShareResultStatus.success => ShareOutcome.shared,
      ShareResultStatus.dismissed => ShareOutcome.dismissed,
      ShareResultStatus.unavailable => ShareOutcome.unavailable,
    };
  }
}
