import 'dart:ui' as ui;

import 'media_processing.dart';

/// Decodes a photo with the platform's codecs (via the Flutter engine), which
/// support formats the pure-Dart decoder does not, such as HEIC on iOS and
/// Android 9+. The engine applies EXIF orientation. Returns null if the
/// platform cannot decode the file either.
///
/// Must run on the root isolate (it needs the engine), but decoding itself
/// happens off the UI thread.
typedef PlatformDecoder = Future<RgbaImage?> Function(String path);

/// Images larger than this many pixels are not decoded (memory bound).
const _maxPixels = 50 * 1000 * 1000;

Future<RgbaImage?> decodeWithPlatform(String path) async {
  ui.ImmutableBuffer? buffer;
  ui.ImageDescriptor? descriptor;
  ui.Codec? codec;
  try {
    buffer = await ui.ImmutableBuffer.fromFilePath(path);
    descriptor = await ui.ImageDescriptor.encoded(buffer);
    if (descriptor.width * descriptor.height > _maxPixels) return null;
    codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final result = data == null
        ? null
        : RgbaImage(data.buffer.asUint8List(), image.width, image.height);
    image.dispose();
    return result;
  } on Object {
    return null;
  } finally {
    codec?.dispose();
    descriptor?.dispose();
    buffer?.dispose();
  }
}
