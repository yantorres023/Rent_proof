import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/database.dart';
import 'report_models.dart';

/// Font bytes loaded from bundled assets (Roboto covers Latin, Greek and
/// Cyrillic). Passed in so the builder can run in a background isolate.
class ReportFonts {
  const ReportFonts({
    required this.regular,
    required this.bold,
    required this.italic,
  });

  final ByteData regular;
  final ByteData bold;
  final ByteData italic;
}

// Colors distinguishing the three kinds of content in the report.
const _mediaColor = PdfColor.fromInt(0xFF1F5AA6); // Original media record
const _notesColor = PdfColor.fromInt(0xFFB26A00); // User notes
const _metaColor = PdfColor.fromInt(0xFF5B6770); // App-generated metadata
const _notesFill = PdfColor.fromInt(0xFFFFF6E5);
const _metaFill = PdfColor.fromInt(0xFFF1F3F5);
const _ink = PdfColor.fromInt(0xFF1B1F23);

final _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
final _date = DateFormat('yyyy-MM-dd');

String _ts(DateTime t) {
  final offset = t.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final h = offset.inHours.abs().toString().padLeft(2, '0');
  final m = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  return '${_dateTime.format(t)} (UTC$sign$h:$m)';
}

/// Removes characters the bundled font cannot render (e.g. emoji) so text
/// never silently disappears or breaks layout.
String pdfSafe(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ok =
        rune == 0x0A ||
        (rune >= 0x20 && rune < 0x7F) ||
        (rune >= 0xA0 && rune <= 0x024F) || // Latin-1 + Latin Extended A/B
        (rune >= 0x0370 && rune <= 0x03FF) || // Greek
        (rune >= 0x0400 && rune <= 0x04FF) || // Cyrillic
        (rune >= 0x1E00 && rune <= 0x1EFF) || // Latin Extended Additional
        (rune >= 0x2010 && rune <= 0x2027) || // dashes, quotes, bullets
        rune == 0x20AC; // Euro sign
    buffer.write(ok ? String.fromCharCode(rune) : '?');
  }
  return buffer.toString();
}

Future<Uint8List> buildReportPdf(ReportInput input, ReportFonts fonts) async {
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(fonts.regular),
    bold: pw.Font.ttf(fonts.bold),
    italic: pw.Font.ttf(fonts.italic),
  );
  final mono = pw.Font.courier();
  final snap = input.snapshot;
  final doc = pw.Document(
    title: pdfSafe('Condition record - ${snap.property.nickname}'),
    author: pdfSafe(input.preparedBy),
    creator: 'RentProof ${input.appVersion}',
    producer: 'RentProof',
    theme: theme,
  );

  final images = <String, pw.MemoryImage?>{};
  pw.MemoryImage? imageFor(String? path) {
    if (path == null) return null;
    return images.putIfAbsent(path, () {
      final f = File(path);
      if (!f.existsSync()) return null;
      try {
        return pw.MemoryImage(f.readAsBytesSync());
      } on Object {
        return null;
      }
    });
  }

  final footerText = pdfSafe(
    'RentProof report ${input.reportId.substring(0, 8)} - '
    'generated ${_ts(input.generatedAt)}',
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 36,
        marginRight: 36,
        marginTop: 36,
        marginBottom: 40,
      ),
      footer: (context) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              footerText,
              style: const pw.TextStyle(fontSize: 7, color: _metaColor),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 7, color: _metaColor),
            ),
          ],
        ),
      ),
      build: (context) => [
        ..._cover(input, mono),
        for (final room in snap.rooms) ..._room(room, snap, imageFor, mono),
        if (input.baseline != null) ..._comparison(input, imageFor),
        ..._index(snap, mono),
        ..._limitations(input),
      ],
    ),
  );
  return doc.save();
}

// ---------------------------------------------------------------------------
// Building blocks

pw.Widget _label(String text, PdfColor color) => pw.Container(
  padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
  decoration: pw.BoxDecoration(
    border: pw.Border.all(color: color, width: 0.8),
    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
  ),
  child: pw.Text(
    text,
    style: pw.TextStyle(
      fontSize: 6.5,
      color: color,
      fontWeight: pw.FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),
);

pw.Widget _notesBox(String title, List<pw.Widget> children) => pw.Container(
  width: double.infinity,
  margin: const pw.EdgeInsets.only(top: 6),
  padding: const pw.EdgeInsets.all(6),
  decoration: const pw.BoxDecoration(
    color: _notesFill,
    border: pw.Border(left: pw.BorderSide(color: _notesColor, width: 2)),
  ),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        children: [
          _label('USER NOTES', _notesColor),
          pw.SizedBox(width: 6),
          pw.Text(
            pdfSafe(title),
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.SizedBox(height: 3),
      ...children,
    ],
  ),
);

pw.Widget _metaBox(List<pw.Widget> children) => pw.Container(
  width: double.infinity,
  padding: const pw.EdgeInsets.all(4),
  decoration: const pw.BoxDecoration(
    color: _metaFill,
    border: pw.Border(left: pw.BorderSide(color: _metaColor, width: 2)),
  ),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: children,
  ),
);

pw.Widget _metaLine(String key, String value, {pw.Font? font}) => pw.Padding(
  padding: const pw.EdgeInsets.only(bottom: 1),
  child: pw.RichText(
    text: pw.TextSpan(
      style: const pw.TextStyle(fontSize: 6.5, color: _ink),
      children: [
        pw.TextSpan(
          text: '$key: ',
          style: const pw.TextStyle(color: _metaColor),
        ),
        pw.TextSpan(
          text: pdfSafe(value),
          style: font == null ? null : pw.TextStyle(font: font),
        ),
      ],
    ),
  ),
);

pw.Widget _heading(String text, {double size = 15}) => pw.Padding(
  padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
  child: pw.Text(
    pdfSafe(text),
    style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold),
  ),
);

String _address(Property p) => [
  p.addressLine1,
  p.addressLine2,
  [p.city, p.region, p.postalCode].where((s) => s.isNotEmpty).join(', '),
  p.country,
].where((s) => s.trim().isNotEmpty).join('\n');

// ---------------------------------------------------------------------------
// Sections

List<pw.Widget> _cover(ReportInput input, pw.Font mono) {
  final snap = input.snapshot;
  final i = snap.inspection;
  final photos = snap.allMedia
      .where((m) => m.media.kind == MediaKind.photo)
      .length;
  final videos = snap.allMedia.length - photos;
  final address = _address(snap.property);
  return [
    pw.Text(
      'Rental condition record',
      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
    ),
    pw.Text(
      '${inspectionTypeLabel(i.type)} inspection',
      style: const pw.TextStyle(fontSize: 13, color: _metaColor),
    ),
    pw.SizedBox(height: 10),
    pw.Text(
      pdfSafe(snap.property.nickname),
      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
    ),
    if (address.isNotEmpty)
      pw.Text(pdfSafe(address), style: const pw.TextStyle(fontSize: 10)),
    if (snap.property.landlordName.isNotEmpty)
      pw.Text(
        pdfSafe('Landlord / manager: ${snap.property.landlordName}'),
        style: const pw.TextStyle(fontSize: 10),
      ),
    if (input.preparedBy.isNotEmpty)
      pw.Text(
        pdfSafe('Prepared by: ${input.preparedBy}'),
        style: const pw.TextStyle(fontSize: 10),
      ),
    pw.SizedBox(height: 10),
    pw.Row(
      children: [
        _label('APP-GENERATED METADATA', _metaColor),
      ],
    ),
    pw.SizedBox(height: 3),
    _metaBox([
      _metaLine('Inspection started (device clock)', _ts(i.startedAt)),
      _metaLine(
        'Inspection completed (device clock)',
        i.completedAt == null ? 'Not completed' : _ts(i.completedAt!),
      ),
      _metaLine('Report generated (device clock)', _ts(input.generatedAt)),
      _metaLine('Report ID', input.reportId, font: mono),
      _metaLine(
        'Contents',
        '${snap.rooms.length} rooms, $photos photos, $videos videos, '
            '${snap.allIssues.length} issues',
      ),
      if (input.baseline != null)
        _metaLine(
          'Compared with',
          '${inspectionTypeLabel(input.baseline!.inspection.type)} inspection '
              'started ${_date.format(input.baseline!.inspection.startedAt)}',
        ),
      _metaLine('Generated with', 'RentProof ${input.appVersion}'),
    ]),
    if (i.notes.isNotEmpty)
      _notesBox('Inspection notes', [
        pw.Text(pdfSafe(i.notes), style: const pw.TextStyle(fontSize: 9)),
      ]),
    pw.SizedBox(height: 10),
    pw.Text(
      'How to read this report',
      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
    ),
    pw.SizedBox(height: 3),
    pw.Row(
      children: [
        _label('ORIGINAL MEDIA RECORD', _mediaColor),
        pw.SizedBox(width: 4),
        pw.Expanded(
          child: pw.Text(
            'Downscaled copies of photos stored by the app. The SHA-256 '
            'refers to the full original file, which is kept unchanged.',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    ),
    pw.SizedBox(height: 3),
    pw.Row(
      children: [
        _label('USER NOTES', _notesColor),
        pw.SizedBox(width: 4),
        pw.Expanded(
          child: pw.Text(
            'Descriptions, issues and markers written by the person who '
            'prepared this report.',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    ),
    pw.SizedBox(height: 3),
    pw.Row(
      children: [
        _label('APP-GENERATED METADATA', _metaColor),
        pw.SizedBox(width: 4),
        pw.Expanded(
          child: pw.Text(
            'Values recorded automatically by the app (device-clock '
            'timestamps, file sizes, hashes). Camera EXIF values are shown '
            'as reported by the file and are not verified.',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    ),
    _heading('Rooms summary', size: 12),
    pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: _metaFill),
      headers: ['Room', 'Status', 'Prompts documented', 'Media', 'Issues'],
      data: [
        for (final r in snap.rooms)
          [
            pdfSafe(r.room.name),
            roomStatusLabel(r.room.status),
            '${r.checklist.where((c) => c.documented || c.notApplicable).length}'
                ' of ${r.checklist.length}',
            '${r.media.length}',
            '${r.issues.length}',
          ],
      ],
    ),
  ];
}

typedef _ImageLookup = pw.MemoryImage? Function(String? path);

List<pw.Widget> _room(
  RoomEntry room,
  InspectionSnapshot snap,
  _ImageLookup imageFor,
  pw.Font mono,
) {
  final widgets = <pw.Widget>[
    pw.NewPage(),
    pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(child: _heading(room.room.name, size: 17)),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Text(
            'Status: ${roomStatusLabel(room.room.status)}',
            style: const pw.TextStyle(fontSize: 9, color: _metaColor),
          ),
        ),
      ],
    ),
    pw.Wrap(
      spacing: 8,
      runSpacing: 2,
      children: [
        for (final c in room.checklist)
          pw.Text(
            pdfSafe(
              '${c.notApplicable
                  ? '[n/a]'
                  : c.documented
                  ? '[x]'
                  : '[ ]'} ${c.label}'
              '${c.documented ? ' (${c.mediaCount})' : ''}',
            ),
            style: const pw.TextStyle(fontSize: 8),
          ),
      ],
    ),
    pw.Text(
      '[x] documented   [ ] not documented   [n/a] marked not applicable',
      style: const pw.TextStyle(fontSize: 6.5, color: _metaColor),
    ),
  ];

  if (room.room.notes.isNotEmpty) {
    widgets.add(
      _notesBox('Room notes', [
        pw.Text(pdfSafe(room.room.notes), style: const pw.TextStyle(fontSize: 9)),
      ]),
    );
  }

  for (final issue in room.issues) {
    final linked = issue.mediaId == null ? null : snap.mediaById(issue.mediaId!);
    widgets.add(
      _notesBox('Issue: ${issue.title}', [
        pw.Text(
          '${severityLabel(issue.severity)} - '
          '${issueCategoryLabel(issue.category)}'
          '${linked == null ? '' : ' - see ${linked.evidenceId}'}',
          style: const pw.TextStyle(fontSize: 8, color: _notesColor),
        ),
        if (issue.description.isNotEmpty)
          pw.Text(
            pdfSafe(issue.description),
            style: const pw.TextStyle(fontSize: 9),
          ),
      ]),
    );
  }

  if (room.media.isEmpty) {
    widgets.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8),
        child: pw.Text(
          'No photos or videos were recorded for this room.',
          style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
        ),
      ),
    );
    return widgets;
  }

  widgets.add(pw.SizedBox(height: 8));
  // Two evidence cards per row.
  for (var i = 0; i < room.media.length; i += 2) {
    final left = room.media[i];
    final right = i + 1 < room.media.length ? room.media[i + 1] : null;
    widgets.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: _evidenceCard(left, room, imageFor, mono)),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: right == null
                  ? pw.SizedBox()
                  : _evidenceCard(right, room, imageFor, mono),
            ),
          ],
        ),
      ),
    );
  }
  return widgets;
}

const _cardWidth = 256.0;
const _maxImageHeight = 220.0;

pw.Widget _evidenceCard(
  MediaEntry entry,
  RoomEntry room,
  _ImageLookup imageFor,
  pw.Font mono,
) {
  final m = entry.media;
  final image = m.kind == MediaKind.photo ? imageFor(entry.previewFile) : null;
  pw.Widget visual;
  if (image != null) {
    final aspect = (m.width != null && m.height != null && m.width! > 0)
        ? m.height! / m.width!
        : 0.75;
    var w = _cardWidth;
    var h = w * aspect;
    if (h > _maxImageHeight) {
      h = _maxImageHeight;
      w = h / aspect;
    }
    visual = pw.SizedBox(
      width: w,
      height: h,
      child: pw.Stack(
        children: [
          pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.fill)),
          for (var i = 0; i < entry.annotations.length; i++)
            pw.Positioned(
              left: entry.annotations[i].x * w - 7,
              top: entry.annotations[i].y * h - 7,
              child: pw.Container(
                width: 14,
                height: 14,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: _notesColor,
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.white, width: 1.2),
                ),
                child: pw.Text(
                  '${i + 1}',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  } else {
    visual = pw.Container(
      width: _cardWidth,
      height: 70,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _mediaColor, width: 0.8),
      ),
      child: pw.Text(
        m.kind == MediaKind.video
            ? 'VIDEO - original file kept in the evidence package'
            : 'Preview unavailable - original file kept in the evidence package',
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 8, color: _mediaColor),
      ),
    );
  }

  final hash = m.sha256;
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        children: [
          _label('ORIGINAL MEDIA RECORD', _mediaColor),
          pw.SizedBox(width: 4),
          pw.Text(
            pdfSafe('${entry.evidenceId}  ${entry.promptLabel ?? 'Other'}'),
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.SizedBox(height: 3),
      visual,
      pw.SizedBox(height: 3),
      _metaBox([
        _metaLine('Recorded by app', _ts(m.recordedAt)),
        _metaLine(
          'Source',
          '${m.source == MediaSource.camera ? 'Camera in app' : 'Imported'}'
              ', ${m.kind.name}, ${formatBytes(m.byteSize)}',
        ),
        _metaLine('SHA-256', hash.substring(0, 32), font: mono),
        _metaLine('', hash.substring(32), font: mono),
        _metaLine(
          'EXIF date (unverified)',
          m.exifDateTimeOriginal ?? 'not present',
        ),
        if (m.exifMake != null || m.exifModel != null)
          _metaLine(
            'EXIF device (unverified)',
            [m.exifMake, m.exifModel].whereType<String>().join(' '),
          ),
      ]),
      if (m.caption.isNotEmpty || entry.annotations.isNotEmpty)
        _notesBox('Note', [
          if (m.caption.isNotEmpty)
            pw.Text(pdfSafe(m.caption), style: const pw.TextStyle(fontSize: 8)),
          for (var i = 0; i < entry.annotations.length; i++)
            pw.Text(
              pdfSafe(
                'Marker ${i + 1}: ${_annotationText(entry.annotations[i], room)}',
              ),
              style: const pw.TextStyle(fontSize: 8),
            ),
        ]),
    ],
  );
}

String _annotationText(Annotation a, RoomEntry room) {
  if (a.label.isNotEmpty) return a.label;
  if (a.issueId != null) {
    for (final issue in room.issues) {
      if (issue.id == a.issueId) return issue.title;
    }
  }
  return 'marked area';
}

List<pw.Widget> _comparison(ReportInput input, _ImageLookup imageFor) {
  final baseline = input.baseline!;
  final widgets = <pw.Widget>[
    pw.NewPage(),
    _heading('Comparison with baseline', size: 17),
    pw.Text(
      pdfSafe(
        'Baseline: ${inspectionTypeLabel(baseline.inspection.type)} '
        'inspection started ${_ts(baseline.inspection.startedAt)}. '
        'This is a side-by-side view prepared manually by the user. '
        'The app does not detect damage automatically.',
      ),
      style: const pw.TextStyle(fontSize: 8.5, color: _metaColor),
    ),
  ];
  for (final pair in input.pairs) {
    final verdict = pair.current?.comparison;
    widgets.add(_heading(pair.name, size: 12));
    if (pair.current == null) {
      widgets.add(
        pw.Text(
          'Room present only in the baseline inspection.',
          style: const pw.TextStyle(fontSize: 8.5),
        ),
      );
    } else if (pair.baseline == null) {
      widgets.add(
        pw.Text(
          'Room not present in the baseline inspection.',
          style: const pw.TextStyle(fontSize: 8.5),
        ),
      );
    }
    widgets.add(
      _notesBox(
        'Verdict: ${verdictLabel(verdict?.verdict ?? ComparisonVerdict.notReviewed)}',
        [
          if (verdict != null && verdict.note.isNotEmpty)
            pw.Text(pdfSafe(verdict.note), style: const pw.TextStyle(fontSize: 8)),
          pw.Text(
            pdfSafe(
              'Issues - baseline: ${pair.baseline?.issues.length ?? 0}'
              '${pair.baseline == null ? '' : _issueTitles(pair.baseline!)}'
              '\nIssues - this inspection: ${pair.current?.issues.length ?? 0}'
              '${pair.current == null ? '' : _issueTitles(pair.current!)}',
            ),
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
    final labels = <String>{
      ...?pair.baseline?.checklist.map((c) => c.label),
      ...?pair.current?.checklist.map((c) => c.label),
    };
    final rows = <pw.TableRow>[];
    for (final label in labels) {
      final b = _firstPhoto(pair.baseline, label);
      final c = _firstPhoto(pair.current, label);
      if (b == null && c == null) continue;
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(pdfSafe(label), style: const pw.TextStyle(fontSize: 8)),
            ),
            _thumbCell(b, imageFor),
            _thumbCell(c, imageFor),
          ],
        ),
      );
    }
    if (rows.isNotEmpty) {
      widgets.add(pw.SizedBox(height: 4));
      widgets.add(
        pw.Table(
          border: pw.TableBorder.all(color: _metaFill, width: 0.8),
          columnWidths: const {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _metaFill),
              children: [
                for (final h in ['Prompt', 'Baseline', 'This inspection'])
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(
                      h,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            ...rows,
          ],
        ),
      );
    }
  }
  return widgets;
}

String _issueTitles(RoomEntry room) =>
    room.issues.isEmpty ? '' : ' (${room.issues.map((i) => i.title).join('; ')})';

MediaEntry? _firstPhoto(RoomEntry? room, String label) {
  if (room == null) return null;
  for (final m in room.media) {
    if (m.promptLabel == label) return m;
  }
  return null;
}

pw.Widget _thumbCell(MediaEntry? entry, _ImageLookup imageFor) {
  if (entry == null) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        'No photo',
        style: const pw.TextStyle(fontSize: 7.5, color: _metaColor),
      ),
    );
  }
  final image = imageFor(entry.thumbnailFile ?? entry.previewFile);
  return pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (image != null)
          pw.SizedBox(
            height: 90,
            child: pw.Image(image, fit: pw.BoxFit.contain),
          )
        else
          pw.Text(
            entry.media.kind == MediaKind.video ? 'Video' : 'No preview',
            style: const pw.TextStyle(fontSize: 7.5),
          ),
        pw.Text(
          '${entry.evidenceId} - ${_date.format(entry.media.recordedAt)}',
          style: const pw.TextStyle(fontSize: 6.5, color: _metaColor),
        ),
      ],
    ),
  );
}

List<pw.Widget> _index(InspectionSnapshot snap, pw.Font mono) {
  if (snap.allMedia.isEmpty) return const [];
  return [
    pw.NewPage(),
    _heading('Evidence index', size: 15),
    pw.Text(
      'Every stored original with the SHA-256 recorded when the app stored '
      'it. Anyone with the original file can recompute this value (for '
      'example with "shasum -a 256 <file>") and compare.',
      style: const pw.TextStyle(fontSize: 8, color: _metaColor),
    ),
    pw.SizedBox(height: 4),
    pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 6.5),
      headerDecoration: const pw.BoxDecoration(color: _metaFill),
      columnWidths: const {
        0: pw.FixedColumnWidth(34),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2.2),
        3: pw.FlexColumnWidth(5),
      },
      headers: ['ID', 'Room / prompt', 'Recorded by app', 'SHA-256'],
      data: [
        for (final room in snap.rooms)
          for (final m in room.media)
            [
              m.evidenceId,
              pdfSafe('${room.room.name} / ${m.promptLabel ?? 'Other'}'),
              _dateTime.format(m.media.recordedAt),
              m.media.sha256,
            ],
      ],
      cellAlignments: const {3: pw.Alignment.centerLeft},
      cellFormat: (index, data) => data.toString(),
    ),
  ];
}

List<pw.Widget> _limitations(ReportInput input) => [
  _heading('What this report is, and is not', size: 12),
  for (final line in reportLimitations)
    pw.Bullet(text: line, style: const pw.TextStyle(fontSize: 8)),
];

/// Plain-language limitations shown in every report and in the app.
const reportLimitations = [
  'This report is an organized record created by the person named above '
      'using the RentProof app. It is not an inspection by a licensed '
      'professional and it is not legal advice.',
  'Timestamps come from the device clock at the moment the app stored each '
      'file. The app cannot prove when a scene actually existed or who '
      'captured it.',
  'A SHA-256 hash shows whether a stored file is bit-for-bit identical to '
      'the file the app recorded. It does not prove the photo is authentic, '
      'unedited before import, or accepted by any court or agency.',
  'EXIF camera metadata is shown as reported by the file. It can be missing '
      'or edited and is not verified by the app.',
  'Photos in this PDF are downscaled copies. The full-resolution originals '
      'are kept unchanged on the device and can be exported in the evidence '
      'package.',
  'Rules about security deposits, inspections and evidence vary by place. '
      'Check the rules that apply to your tenancy or ask a qualified adviser.',
];
