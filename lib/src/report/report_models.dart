import '../data/database.dart';

/// Immutable, isolate-sendable snapshot of everything a report needs.
class MediaEntry {
  const MediaEntry({
    required this.evidenceId,
    required this.media,
    required this.promptLabel,
    required this.annotations,
    this.previewFile,
    this.thumbnailFile,
  });

  /// Short, human-friendly identifier used in the report (e.g. `E-007`).
  final String evidenceId;
  final MediaItem media;
  final String? promptLabel;
  final List<Annotation> annotations;

  /// Absolute paths of derived images (may be null or missing).
  final String? previewFile;
  final String? thumbnailFile;
}

class RoomEntry {
  const RoomEntry({
    required this.room,
    required this.checklist,
    required this.media,
    required this.issues,
    this.comparison,
  });

  final Room room;
  final List<ChecklistLine> checklist;
  final List<MediaEntry> media;
  final List<Issue> issues;
  final RoomComparison? comparison;
}

class ChecklistLine {
  const ChecklistLine({
    required this.label,
    required this.mediaCount,
    required this.notApplicable,
  });

  final String label;
  final int mediaCount;
  final bool notApplicable;

  bool get documented => mediaCount > 0;
}

class InspectionSnapshot {
  const InspectionSnapshot({
    required this.property,
    required this.inspection,
    required this.rooms,
  });

  final Property property;
  final Inspection inspection;
  final List<RoomEntry> rooms;

  Iterable<MediaEntry> get allMedia => rooms.expand((r) => r.media);
  Iterable<Issue> get allIssues => rooms.expand((r) => r.issues);

  MediaEntry? mediaById(String id) {
    for (final m in allMedia) {
      if (m.media.id == id) return m;
    }
    return null;
  }
}

/// A current room paired with its baseline counterpart (either may be null).
class RoomPair {
  const RoomPair({this.current, this.baseline});

  final RoomEntry? current;
  final RoomEntry? baseline;

  String get name => current?.room.name ?? baseline!.room.name;
}

class ReportInput {
  const ReportInput({
    required this.reportId,
    required this.generatedAt,
    required this.snapshot,
    required this.appVersion,
    required this.preparedBy,
    this.baseline,
    this.pairs = const [],
  });

  final String reportId;
  final DateTime generatedAt;
  final InspectionSnapshot snapshot;
  final InspectionSnapshot? baseline;
  final List<RoomPair> pairs;
  final String appVersion;
  final String preparedBy;
}

String inspectionTypeLabel(InspectionType t) => switch (t) {
  InspectionType.moveIn => 'Move-in',
  InspectionType.moveOut => 'Move-out',
  InspectionType.routine => 'Routine check',
  InspectionType.maintenance => 'Maintenance issue',
};

String issueCategoryLabel(IssueCategory c) => switch (c) {
  IssueCategory.damage => 'Damage',
  IssueCategory.wearAndTear => 'Wear and tear',
  IssueCategory.stainOrDirt => 'Stain or dirt',
  IssueCategory.missingItem => 'Missing item',
  IssueCategory.notWorking => 'Not working',
  IssueCategory.moldOrMoisture => 'Mold or moisture',
  IssueCategory.pests => 'Pests',
  IssueCategory.safety => 'Safety',
  IssueCategory.other => 'Other',
};

String severityLabel(IssueSeverity s) => switch (s) {
  IssueSeverity.minor => 'Minor',
  IssueSeverity.moderate => 'Moderate',
  IssueSeverity.major => 'Major',
};

String roomStatusLabel(RoomStatus s) => switch (s) {
  RoomStatus.notStarted => 'Not started',
  RoomStatus.inProgress => 'In progress',
  RoomStatus.completed => 'Done',
};

String verdictLabel(ComparisonVerdict v) => switch (v) {
  ComparisonVerdict.notReviewed => 'Not reviewed',
  ComparisonVerdict.noChange => 'No visible change',
  ComparisonVerdict.changed => 'Changed',
  ComparisonVerdict.newIssue => 'New issue',
};

String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
