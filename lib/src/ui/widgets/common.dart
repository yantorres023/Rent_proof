import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/inspection_repository.dart';
import '../../data/property_repository.dart';
import '../../services/media_picker.dart';
import '../../services/media_processing.dart';

final dateFormat = DateFormat.yMMMd();
final dateTimeFormat = DateFormat.yMMMd().add_jm();

/// Renders loading / error / data states of an [AsyncValue] consistently.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.builder});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => const Center(
        child: CircularProgressIndicator(semanticsLabel: 'Loading'),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            describeError(e),
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 56, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// Status shown with icon + text so it never relies on color alone.
class StatusLabel extends StatelessWidget {
  const StatusLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Icon(icon, size: 18, color: color)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

/// Small image loaded at display size to avoid decoding full images.
class FileThumb extends StatelessWidget {
  const FileThumb({
    super.key,
    required this.path,
    required this.semanticLabel,
    this.size = 88,
    this.isVideo = false,
  });

  final String? path;
  final String semanticLabel;
  final double size;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final px = (size * MediaQuery.devicePixelRatioOf(context)).round();
    Widget placeholder(IconData icon) => Container(
      width: size,
      height: size,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(icon, color: scheme.onSurfaceVariant),
    );
    Widget child;
    if (isVideo) {
      child = placeholder(Icons.videocam_outlined);
    } else if (path == null) {
      child = placeholder(Icons.image_not_supported_outlined);
    } else {
      child = Image.file(
        File(path!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: px,
        errorBuilder: (_, _, _) => placeholder(Icons.broken_image_outlined),
      );
    }
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: child),
    );
  }
}

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String label = '',
  String confirmLabel = 'Save',
  int maxLength = 80,
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: label.isEmpty ? null : label),
        onSubmitted: maxLines == 1 ? (v) => Navigator.pop(context, v) : null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Maps internal exceptions to plain-language messages. Never includes file
/// paths or stack traces.
String describeError(Object error) {
  return switch (error) {
    MediaPermissionDeniedException(camera: true) =>
      'Camera access is off. You can turn it on in your phone Settings, '
          'or import photos instead.',
    MediaPermissionDeniedException() =>
      'Photo access is off. You can turn it on in your phone Settings.',
    CameraUnavailableException() =>
      'No camera is available on this device. Try importing instead.',
    MediaProcessingException(code: 'no_space') =>
      'Your phone is out of storage. Free up space and try again. '
          'Nothing was saved.',
    MediaProcessingException(code: 'source_missing') =>
      'That file could not be found. It may have been moved or deleted.',
    MediaProcessingException(code: 'empty_file') =>
      'That file is empty and was not added.',
    MediaProcessingException(code: 'verify_failed') =>
      'The stored copy did not match the original, so it was not saved. '
          'Please try again.',
    MediaProcessingException() => 'That file could not be saved.',
    InspectionLockedException() =>
      'This inspection is finished. Reopen it to make changes.',
    InspectionNotReadyException() =>
      'Add at least one photo or video before finishing.',
    ValidationException(field: final f) => 'Please check the $f field.',
    FileSystemException() =>
      'A file could not be read or written. Check free storage and retry.',
    _ => 'Something went wrong. Please try again.',
  };
}

/// Runs [action] and shows a snackbar for any failure.
Future<T?> runGuarded<T>(
  BuildContext context,
  Future<T> Function() action,
) async {
  try {
    return await action();
  } on Object catch (e) {
    if (context.mounted) showMessage(context, describeError(e));
    return null;
  }
}
