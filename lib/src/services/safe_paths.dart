import 'package:path/path.dart' as p;

/// File extensions the app will store. Anything else is stored as `.bin`
/// so an attacker-controlled name can never choose the stored extension.
const allowedPhotoExtensions = {
  'jpg',
  'jpeg',
  'png',
  'heic',
  'heif',
  'webp',
  'gif',
};
const allowedVideoExtensions = {'mp4', 'mov', 'm4v', '3gp', 'webm'};

/// Returns a lowercase, allow-listed extension (without dot) for [fileName].
String safeExtension(String fileName) {
  final ext = p.extension(fileName).replaceFirst('.', '').toLowerCase();
  if (allowedPhotoExtensions.contains(ext) ||
      allowedVideoExtensions.contains(ext)) {
    return ext;
  }
  return 'bin';
}

String mimeTypeForExtension(String ext) => switch (ext) {
  'jpg' || 'jpeg' => 'image/jpeg',
  'png' => 'image/png',
  'heic' => 'image/heic',
  'heif' => 'image/heif',
  'webp' => 'image/webp',
  'gif' => 'image/gif',
  'mp4' => 'video/mp4',
  'mov' => 'video/quicktime',
  'm4v' => 'video/x-m4v',
  '3gp' => 'video/3gpp',
  'webm' => 'video/webm',
  _ => 'application/octet-stream',
};

/// Makes a display-only file name safe: strips directories, control
/// characters and path separators, and caps the length.
String sanitizeDisplayFileName(String input) {
  var name = input.split(RegExp(r'[\\/]')).last;
  name = name.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  name = name.replaceAll(RegExp(r'[<>:"|?*]'), '_').trim();
  if (name == '.' || name == '..') name = '';
  if (name.length > 100) {
    final ext = p.extension(name);
    final keep = 100 - ext.length;
    name = name.substring(0, keep < 1 ? 100 : keep) + (keep < 1 ? '' : ext);
  }
  return name;
}

/// Makes a string safe to use as part of an exported file name.
String slugForFileName(String input, {String fallback = 'export'}) {
  final slug = input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  if (slug.isEmpty) return fallback;
  return slug.length > 40 ? slug.substring(0, 40) : slug;
}

/// Resolves [relative] under [root], rejecting anything that escapes it.
String resolveWithin(String root, String relative) {
  if (relative.isEmpty || p.isAbsolute(relative)) {
    throw ArgumentError.value(relative, 'relative', 'must be relative');
  }
  final full = p.normalize(p.join(root, relative));
  if (!p.isWithin(p.normalize(root), full)) {
    throw ArgumentError.value(relative, 'relative', 'escapes storage root');
  }
  return full;
}
