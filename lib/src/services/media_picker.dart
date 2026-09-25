import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/enums.dart';

/// A file handed to the app by the camera or the system picker.
class PickedMedia {
  const PickedMedia({
    required this.path,
    required this.name,
    required this.kind,
    required this.source,
  });

  final String path;
  final String name;
  final MediaKind kind;
  final MediaSource source;
}

/// The user (or OS policy) denied camera or photo access.
class MediaPermissionDeniedException implements Exception {
  const MediaPermissionDeniedException(this.camera);

  /// True for camera, false for photo library.
  final bool camera;
}

/// The device has no usable camera (e.g. some emulators/tablets).
class CameraUnavailableException implements Exception {
  const CameraUnavailableException();
}

abstract interface class MediaPicker {
  Future<PickedMedia?> capturePhoto();
  Future<PickedMedia?> captureVideo();
  Future<List<PickedMedia>> importPhotos();
  Future<PickedMedia?> importVideo();

  /// On Android the app may be killed while the camera is open. Returns
  /// media that was captured before the app restarted.
  Future<List<PickedMedia>> retrieveLost();
}

/// [MediaPicker] backed by the image_picker plugin. It uses the system
/// photo picker (no broad storage permission on Android) and asks for the
/// camera permission only when the user taps a capture button.
class ImagePickerMediaPicker implements MediaPicker {
  ImagePickerMediaPicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Short clips keep files manageable; a walkthrough video longer than
  /// this is better split per room.
  static const maxVideoDuration = Duration(minutes: 2);

  PickedMedia _wrap(XFile f, MediaKind kind, MediaSource source) =>
      PickedMedia(path: f.path, name: f.name, kind: kind, source: source);

  Future<T> _guard<T>(bool camera, Future<T> Function() run) async {
    try {
      return await run();
    } on PlatformException catch (e) {
      final code = e.code.toLowerCase();
      if (code.contains('access_denied') || code.contains('permission')) {
        throw MediaPermissionDeniedException(camera);
      }
      if (code.contains('no_available_camera') || code.contains('camera')) {
        throw const CameraUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<PickedMedia?> capturePhoto() => _guard(true, () async {
    // No resizing or quality options: the app keeps the file as delivered.
    final f = await _picker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );
    return f == null ? null : _wrap(f, MediaKind.photo, MediaSource.camera);
  });

  @override
  Future<PickedMedia?> captureVideo() => _guard(true, () async {
    final f = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: maxVideoDuration,
    );
    return f == null ? null : _wrap(f, MediaKind.video, MediaSource.camera);
  });

  @override
  Future<List<PickedMedia>> importPhotos() => _guard(false, () async {
    final files = await _picker.pickMultiImage(requestFullMetadata: true);
    return [
      for (final f in files) _wrap(f, MediaKind.photo, MediaSource.import),
    ];
  });

  @override
  Future<PickedMedia?> importVideo() => _guard(false, () async {
    final f = await _picker.pickVideo(source: ImageSource.gallery);
    return f == null ? null : _wrap(f, MediaKind.video, MediaSource.import);
  });

  @override
  Future<List<PickedMedia>> retrieveLost() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) return const [];
    final files = response.files ?? const <XFile>[];
    final kind = response.type == RetrieveType.video
        ? MediaKind.video
        : MediaKind.photo;
    return [for (final f in files) _wrap(f, kind, MediaSource.camera)];
  }
}
