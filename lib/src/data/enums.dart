/// Domain enums persisted by name in the database.
///
/// Values are stored with `textEnum`, so renaming an enum value is a schema
/// change and requires a migration. Adding new values is safe.
library;

enum InspectionType {
  moveIn,
  moveOut,
  routine,
  maintenance;

  bool get isMoveOut => this == InspectionType.moveOut;
}

enum InspectionStatus { inProgress, completed }

enum RoomStatus { notStarted, inProgress, completed }

enum MediaKind { photo, video }

enum MediaSource { camera, import }

enum IssueSeverity { minor, moderate, major }

enum IssueCategory {
  damage,
  wearAndTear,
  stainOrDirt,
  missingItem,
  notWorking,
  moldOrMoisture,
  pests,
  safety,
  other,
}

/// Result of recomputing the SHA-256 of a stored original.
enum HashCheckResult {
  /// The hash computed when the file was stored by the app.
  recorded,

  /// Recomputed hash equals the recorded hash.
  match,

  /// Recomputed hash differs from the recorded hash.
  mismatch,

  /// The stored original could not be found or read.
  missing,
}

enum HashPurpose { import, verification }

/// A user's manual verdict when comparing a room against the baseline.
enum ComparisonVerdict { notReviewed, noChange, changed, newIssue }
