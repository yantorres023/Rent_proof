import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'enums.dart';

export 'enums.dart';

part 'database.g.dart';

/// Optional details about the person preparing reports. Single row (id = 1).
class UserProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Simple key/value application settings (onboarding flag, etc.).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class Properties extends Table {
  TextColumn get id => text()();
  TextColumn get nickname => text().withLength(min: 1, max: 120)();
  TextColumn get addressLine1 => text().withDefault(const Constant(''))();
  TextColumn get addressLine2 => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get region => text().withDefault(const Constant(''))();
  TextColumn get postalCode => text().withDefault(const Constant(''))();
  TextColumn get country => text().withDefault(const Constant(''))();
  TextColumn get landlordName => text().withDefault(const Constant(''))();
  DateTimeColumn get leaseStart => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Inspections extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId =>
      text().references(Properties, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<InspectionType>()();
  TextColumn get status => textEnum<InspectionStatus>()();

  /// Earlier inspection of the same property used for comparison.
  TextColumn get baselineInspectionId => text().nullable().references(
    Inspections,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get inspectionId =>
      text().references(Inspections, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 80)();

  /// Key of the room template used to create this room (e.g. `kitchen`).
  TextColumn get templateKey => text().withDefault(const Constant('custom'))();
  IntColumn get position => integer()();
  TextColumn get status => textEnum<RoomStatus>()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// Matching room in the baseline inspection, if any.
  TextColumn get baselineRoomId => text().nullable().references(
    Rooms,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Guided capture prompts for a room (e.g. "Floor", "Windows").
class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get roomId =>
      text().references(Rooms, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text().withLength(min: 1, max: 80)();
  IntColumn get position => integer()();

  /// The user marked this prompt as not present in the unit.
  BoolColumn get notApplicable =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// A photo or video stored by the app. The original file is never modified.
@DataClassName('MediaItem')
class MediaEvidence extends Table {
  TextColumn get id => text()();
  TextColumn get roomId =>
      text().references(Rooms, #id, onDelete: KeyAction.cascade)();
  TextColumn get checklistItemId => text().nullable().references(
    ChecklistItems,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get kind => textEnum<MediaKind>()();
  TextColumn get source => textEnum<MediaSource>()();

  /// Path of the stored original, relative to the evidence root directory.
  TextColumn get originalPath => text()();

  /// Derived, downscaled copies (relative paths). Null if not derivable.
  TextColumn get previewPath => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();

  /// File name as provided by the OS picker/camera (sanitized).
  TextColumn get sourceFileName => text().withDefault(const Constant(''))();
  TextColumn get mimeType => text().withDefault(const Constant(''))();
  IntColumn get byteSize => integer()();

  /// Lowercase hex SHA-256 of the stored original at storage time.
  TextColumn get sha256 => text().withLength(min: 64, max: 64)();

  /// When the app received and stored the file (device clock).
  DateTimeColumn get recordedAt => dateTime()();

  /// Raw EXIF DateTimeOriginal as reported by the file, if any. Unverified.
  TextColumn get exifDateTimeOriginal => text().nullable()();
  TextColumn get exifMake => text().nullable()();
  TextColumn get exifModel => text().nullable()();

  /// Whether the original file contains GPS metadata (values not stored).
  BoolColumn get originalHasGps =>
      boolean().withDefault(const Constant(false))();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  TextColumn get caption => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Every hash computation over a stored original (initial + verifications).
@DataClassName('EvidenceHash')
class EvidenceHashes extends Table {
  TextColumn get id => text()();
  TextColumn get mediaId =>
      text().references(MediaEvidence, #id, onDelete: KeyAction.cascade)();
  TextColumn get algorithm => text().withDefault(const Constant('SHA-256'))();
  TextColumn get hexDigest => text().nullable()();
  TextColumn get purpose => textEnum<HashPurpose>()();
  TextColumn get result => textEnum<HashCheckResult>()();
  DateTimeColumn get computedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Issues extends Table {
  TextColumn get id => text()();
  TextColumn get roomId =>
      text().references(Rooms, #id, onDelete: KeyAction.cascade)();

  /// Photo that shows the issue, if any.
  TextColumn get mediaId => text().nullable().references(
    MediaEvidence,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get category => textEnum<IssueCategory>()();
  TextColumn get severity => textEnum<IssueSeverity>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A marker placed on a photo. Stored as metadata; the photo is not altered.
class Annotations extends Table {
  TextColumn get id => text()();
  TextColumn get mediaId =>
      text().references(MediaEvidence, #id, onDelete: KeyAction.cascade)();
  TextColumn get issueId => text().nullable().references(
    Issues,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// Normalized position (0..1) relative to the displayed image.
  RealColumn get x => real()();
  RealColumn get y => real()();
  TextColumn get label => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get inspectionId =>
      text().references(Inspections, #id, onDelete: KeyAction.cascade)();

  /// Path relative to the reports root directory.
  TextColumn get filePath => text()();
  TextColumn get sha256 => text().withLength(min: 64, max: 64)();
  IntColumn get byteSize => integer()();
  IntColumn get mediaCount => integer()();
  IntColumn get issueCount => integer()();
  BoolColumn get includesComparison =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get generatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Manual comparison verdict for a room of a later inspection vs baseline.
class RoomComparisons extends Table {
  TextColumn get id => text()();
  TextColumn get roomId =>
      text().references(Rooms, #id, onDelete: KeyAction.cascade)();
  TextColumn get verdict => textEnum<ComparisonVerdict>()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {roomId},
  ];
}

@DriftDatabase(
  tables: [
    UserProfiles,
    AppSettings,
    Properties,
    Inspections,
    Rooms,
    ChecklistItems,
    MediaEvidence,
    EvidenceHashes,
    Issues,
    Annotations,
    Reports,
    RoomComparisons,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens the on-device database in the app's private support directory.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'rentproof_v1'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (m, from, to) async {
      // Step-by-step migrations are added here as the schema evolves, e.g.
      // if (from < 2) { await m.addColumn(...); }
      // Every step must be covered by a test in test/data/migration_test.dart.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createIndexes() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS idx_inspections_property '
          'ON inspections (property_id)',
      'CREATE INDEX IF NOT EXISTS idx_rooms_inspection ON rooms (inspection_id)',
      'CREATE INDEX IF NOT EXISTS idx_checklist_room ON checklist_items (room_id)',
      'CREATE INDEX IF NOT EXISTS idx_media_room ON media_evidence (room_id)',
      'CREATE INDEX IF NOT EXISTS idx_issues_room ON issues (room_id)',
      'CREATE INDEX IF NOT EXISTS idx_hashes_media ON evidence_hashes (media_id)',
      'CREATE INDEX IF NOT EXISTS idx_annotations_media '
          'ON annotations (media_id)',
      'CREATE INDEX IF NOT EXISTS idx_reports_inspection '
          'ON reports (inspection_id)',
    ];
    for (final s in statements) {
      await customStatement(s);
    }
  }
}
