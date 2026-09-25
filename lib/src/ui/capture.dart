import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../providers.dart';
import '../services/media_picker.dart';
import 'widgets/common.dart';

enum CaptureAction { photo, video, importPhotos, importVideo }

/// Shared capture/import flow used by room prompts.
///
/// Returns the number of files stored. Errors are shown to the user.
Future<int> runCapture(
  BuildContext context,
  WidgetRef ref, {
  required String roomId,
  required String? checklistItemId,
  required CaptureAction action,
  ValueChanged<bool>? onBusy,
}) async {
  final picker = ref.read(mediaPickerProvider);
  final settings = ref.read(settingsRepositoryProvider);
  final evidence = ref.read(evidenceRepositoryProvider);
  final usesCamera =
      action == CaptureAction.photo || action == CaptureAction.video;

  List<PickedMedia> picked;
  try {
    if (usesCamera) await settings.setPendingCapture(roomId, checklistItemId);
    picked = switch (action) {
      CaptureAction.photo => [?await picker.capturePhoto()],
      CaptureAction.video => [?await picker.captureVideo()],
      CaptureAction.importPhotos => await picker.importPhotos(),
      CaptureAction.importVideo => [?await picker.importVideo()],
    };
  } on Object catch (e) {
    if (context.mounted) showMessage(context, describeError(e));
    return 0;
  } finally {
    if (usesCamera) await settings.clearPendingCapture();
  }
  if (picked.isEmpty) return 0;

  onBusy?.call(true);
  var stored = 0;
  Object? firstError;
  try {
    for (final m in picked) {
      try {
        await evidence.addMedia(
          roomId: roomId,
          checklistItemId: checklistItemId,
          sourcePath: m.path,
          sourceFileName: m.name,
          kind: m.kind,
          source: m.source,
        );
        stored++;
      } on Object catch (e) {
        firstError ??= e;
      }
    }
  } finally {
    onBusy?.call(false);
  }
  if (context.mounted) {
    if (firstError != null) {
      final failed = picked.length - stored;
      showMessage(
        context,
        picked.length == 1
            ? describeError(firstError)
            : '$stored saved, $failed not saved. ${describeError(firstError)}',
      );
    } else if (stored > 1) {
      showMessage(context, '$stored files saved');
    }
  }
  return stored;
}

/// Android only: stores media captured just before the OS killed the app,
/// in the room/prompt that was active when the camera opened.
Future<void> recoverLostCaptures(BuildContext context, WidgetRef ref) async {
  if (!Platform.isAndroid) return;
  final settings = ref.read(settingsRepositoryProvider);
  List<PickedMedia> lost;
  try {
    lost = await ref.read(mediaPickerProvider).retrieveLost();
  } on Object {
    return;
  }
  final target = await settings.takePendingCapture();
  if (lost.isEmpty || target == null) return;
  final room = await ref
      .read(inspectionRepositoryProvider)
      .findRoom(target.roomId);
  if (room == null) return;
  var stored = 0;
  for (final m in lost) {
    try {
      await ref
          .read(evidenceRepositoryProvider)
          .addMedia(
            roomId: room.id,
            checklistItemId: target.checklistItemId,
            sourcePath: m.path,
            sourceFileName: m.name,
            kind: m.kind,
            source: MediaSource.camera,
          );
      stored++;
    } on Object {
      // Locked or missing: nothing else to do; the file stays in cache.
    }
  }
  if (stored > 0 && context.mounted) {
    showMessage(
      context,
      'Recovered $stored ${stored == 1 ? 'photo' : 'files'} into '
      '"${room.name}" after the app restarted.',
    );
  }
}
