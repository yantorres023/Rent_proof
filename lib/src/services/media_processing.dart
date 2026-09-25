import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;

/// Size (longest edge, px) of the derived preview used in reports.
const previewMaxEdge = 1600;

/// Size (longest edge, px) of the derived thumbnail used in lists.
const thumbnailMaxEdge = 360;

/// Photos larger than this are stored and hashed but no preview is derived,
/// to bound memory use on low-end devices.
const maxDecodableBytes = 40 * 1024 * 1024;

class MediaProcessRequest {
  const MediaProcessRequest({
    required this.sourcePath,
    required this.originalDestPath,
    required this.previewDestPath,
    required this.thumbnailDestPath,
    required this.isPhoto,
  });

  final String sourcePath;
  final String originalDestPath;
  final String? previewDestPath;
  final String? thumbnailDestPath;
  final bool isPhoto;
}

class MediaProcessResult {
  const MediaProcessResult({
    required this.sha256,
    required this.byteSize,
    required this.previewWritten,
    required this.thumbnailWritten,
    this.width,
    this.height,
    this.exifDateTimeOriginal,
    this.exifMake,
    this.exifModel,
    this.hasGps = false,
  });

  final String sha256;
  final int byteSize;
  final bool previewWritten;
  final bool thumbnailWritten;
  final int? width;
  final int? height;
  final String? exifDateTimeOriginal;
  final String? exifMake;
  final String? exifModel;
  final bool hasGps;
}

class MediaProcessingException implements Exception {
  const MediaProcessingException(this.code, [this.detail]);

  /// One of: `source_missing`, `empty_file`, `copy_failed`,
  /// `verify_failed`, `no_space`.
  final String code;
  final String? detail;

  @override
  String toString() => 'MediaProcessingException($code)';
}

/// Streams [file] through SHA-256 without loading it fully into memory.
Future<String> sha256OfFile(String path) async {
  final digest = await sha256.bind(File(path).openRead()).first;
  return digest.toString();
}

/// Copies the source into private storage, hashing the bytes as they are
/// written, re-reads the stored copy to verify the hash, then derives a
/// preview and a thumbnail for photos. The stored original is never
/// modified afterwards. Intended to run inside `Isolate.run`.
Future<MediaProcessResult> processMedia(MediaProcessRequest req) async {
  final source = File(req.sourcePath);
  if (!source.existsSync()) {
    throw const MediaProcessingException('source_missing');
  }
  final dest = File(req.originalDestPath);
  dest.parent.createSync(recursive: true);

  final output = AccumulatorSink<Digest>();
  final hasher = sha256.startChunkedConversion(output);
  var size = 0;
  IOSink? sink;
  try {
    sink = dest.openWrite();
    await for (final chunk in source.openRead()) {
      hasher.add(chunk);
      sink.add(chunk);
      size += chunk.length;
    }
    await sink.flush();
    await sink.close();
    sink = null;
  } on FileSystemException catch (e) {
    await sink?.close().catchError((_) {});
    _deleteQuietly(dest);
    // ENOSPC is errno 28 on Linux/Android and iOS/macOS.
    if (e.osError?.errorCode == 28) {
      throw const MediaProcessingException('no_space');
    }
    throw MediaProcessingException('copy_failed', e.osError?.message);
  }
  hasher.close();
  final writtenHash = output.events.single.toString();

  if (size == 0) {
    _deleteQuietly(dest);
    throw const MediaProcessingException('empty_file');
  }
  final storedHash = await sha256OfFile(dest.path);
  if (storedHash != writtenHash) {
    _deleteQuietly(dest);
    throw const MediaProcessingException('verify_failed');
  }

  if (!req.isPhoto || size > maxDecodableBytes) {
    return MediaProcessResult(
      sha256: storedHash,
      byteSize: size,
      previewWritten: false,
      thumbnailWritten: false,
    );
  }

  final bytes = await dest.readAsBytes();
  final meta = readPhotoMetadata(bytes);
  var previewWritten = false;
  var thumbWritten = false;
  int? width;
  int? height;
  try {
    final decoded = img.decodeImage(bytes);
    if (decoded != null) {
      // Apply EXIF orientation to the derived copies only.
      final oriented = img.bakeOrientation(decoded);
      width = oriented.width;
      height = oriented.height;
      if (req.previewDestPath != null) {
        final preview = _resize(oriented, previewMaxEdge);
        // Derived JPEGs carry no EXIF (no GPS, no device identifiers).
        preview.exif = img.ExifData();
        File(req.previewDestPath!)
            .writeAsBytesSync(img.encodeJpg(preview, quality: 82));
        previewWritten = true;
        if (req.thumbnailDestPath != null) {
          final thumb = _resize(preview, thumbnailMaxEdge);
          thumb.exif = img.ExifData();
          File(req.thumbnailDestPath!)
              .writeAsBytesSync(img.encodeJpg(thumb, quality: 75));
          thumbWritten = true;
        }
      }
    }
  } on Object {
    // Undecodable (e.g. HEIC or corrupted). The original is still stored and
    // hashed; the UI and report show a "preview unavailable" placeholder.
    if (req.previewDestPath != null) _deleteQuietly(File(req.previewDestPath!));
    previewWritten = false;
    thumbWritten = false;
  }

  return MediaProcessResult(
    sha256: storedHash,
    byteSize: size,
    previewWritten: previewWritten,
    thumbnailWritten: thumbWritten,
    width: width,
    height: height,
    exifDateTimeOriginal: meta.dateTimeOriginal,
    exifMake: meta.make,
    exifModel: meta.model,
    hasGps: meta.hasGps,
  );
}

class PhotoMetadata {
  const PhotoMetadata({
    this.dateTimeOriginal,
    this.make,
    this.model,
    this.hasGps = false,
  });

  final String? dateTimeOriginal;
  final String? make;
  final String? model;
  final bool hasGps;
}

/// Reads a few EXIF fields. EXIF is user-editable and never trusted as proof;
/// it is recorded separately from the app's own timestamp.
PhotoMetadata readPhotoMetadata(Uint8List bytes) {
  try {
    final exif = img.decodeJpgExif(bytes);
    if (exif == null || exif.isEmpty) return const PhotoMetadata();
    String? clean(String? v) {
      if (v == null) return null;
      final t = v.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '').trim();
      if (t.isEmpty) return null;
      return t.length > 64 ? t.substring(0, 64) : t;
    }

    return PhotoMetadata(
      dateTimeOriginal: clean(exif.exifIfd[0x9003]?.toString()),
      make: clean(exif.imageIfd.make),
      model: clean(exif.imageIfd.model),
      hasGps: !exif.gpsIfd.isEmpty,
    );
  } on Object {
    return const PhotoMetadata();
  }
}

/// Raw RGBA pixels decoded by the platform (see platform_preview.dart).
class RgbaImage {
  const RgbaImage(this.bytes, this.width, this.height);

  final Uint8List bytes;
  final int width;
  final int height;
}

class DerivedFromRgbaRequest {
  const DerivedFromRgbaRequest({
    required this.image,
    required this.previewDestPath,
    required this.thumbnailDestPath,
  });

  final RgbaImage image;
  final String previewDestPath;
  final String thumbnailDestPath;
}

/// Writes preview and thumbnail JPEGs (no EXIF) from already-decoded pixels.
/// Used when the pure-Dart decoder cannot read a format (e.g. HEIC) but the
/// platform can. Intended to run inside `Isolate.run`.
bool writeDerivedFromRgba(DerivedFromRgbaRequest req) {
  try {
    final src = img.Image.fromBytes(
      width: req.image.width,
      height: req.image.height,
      bytes: req.image.bytes.buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );
    final preview = _resize(src, previewMaxEdge);
    File(req.previewDestPath)
        .writeAsBytesSync(img.encodeJpg(preview, quality: 82));
    final thumb = _resize(preview, thumbnailMaxEdge);
    File(req.thumbnailDestPath)
        .writeAsBytesSync(img.encodeJpg(thumb, quality: 75));
    return true;
  } on Object {
    _deleteQuietly(File(req.previewDestPath));
    _deleteQuietly(File(req.thumbnailDestPath));
    return false;
  }
}

img.Image _resize(img.Image src, int maxEdge) {
  if (src.width <= maxEdge && src.height <= maxEdge) return src.clone();
  return src.width >= src.height
      ? img.copyResize(src, width: maxEdge)
      : img.copyResize(src, height: maxEdge);
}

void _deleteQuietly(File f) {
  try {
    if (f.existsSync()) f.deleteSync();
  } on FileSystemException {
    // Best effort cleanup.
  }
}

/// Minimal sink used to collect the digest from a chunked conversion.
class AccumulatorSink<T> implements Sink<T> {
  final List<T> events = [];

  @override
  void add(T event) => events.add(event);

  @override
  void close() {}
}
