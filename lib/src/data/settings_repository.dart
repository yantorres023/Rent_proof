import 'dart:convert';

import 'package:drift/drift.dart';

import '../services/clock.dart';
import '../services/storage_paths.dart';
import 'database.dart';

class SettingsRepository {
  SettingsRepository(
    this._db,
    this._paths, {
    this._clock = const SystemClock(),
  });

  final AppDatabase _db;
  final StoragePaths _paths;
  final Clock _clock;

  static const _onboardingKey = 'onboarding_completed';

  Stream<bool> watchOnboardingCompleted() =>
      (_db.select(_db.appSettings)..where((t) => t.key.equals(_onboardingKey)))
          .watchSingleOrNull()
          .map((row) => row?.value == 'true');

  Future<void> setOnboardingCompleted() => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _onboardingKey, value: 'true'),
      );

  static const _pendingCaptureKey = 'pending_capture';

  /// Remembers where a camera capture should go, so media recovered after
  /// Android kills the app during capture lands in the right room.
  Future<void> setPendingCapture(String roomId, String? checklistItemId) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          key: _pendingCaptureKey,
          value: jsonEncode({'room': roomId, 'item': checklistItemId}),
        ),
      );

  Future<({String roomId, String? checklistItemId})?>
  takePendingCapture() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(_pendingCaptureKey))).getSingleOrNull();
    if (row == null) return null;
    await clearPendingCapture();
    try {
      final map = jsonDecode(row.value) as Map<String, dynamic>;
      return (
        roomId: map['room'] as String,
        checklistItemId: map['item'] as String?,
      );
    } on Object {
      return null;
    }
  }

  Future<void> clearPendingCapture() => (_db.delete(
    _db.appSettings,
  )..where((t) => t.key.equals(_pendingCaptureKey))).go();

  Stream<UserProfile?> watchProfile() =>
      _db.select(_db.userProfiles).watchSingleOrNull();

  Future<void> saveProfile({required String name, required String email}) {
    String clean(String s, int max) {
      final t = s.trim();
      return t.length > max ? t.substring(0, max) : t;
    }

    return _db
        .into(_db.userProfiles)
        .insertOnConflictUpdate(
          UserProfilesCompanion(
            id: const Value(1),
            displayName: Value(clean(name, 80)),
            email: Value(clean(email, 120)),
            updatedAt: Value(_clock.now()),
          ),
        );
  }

  Future<int> storageUsedBytes() => _paths.usedBytes();

  /// Erases every record and file created by the app on this device.
  Future<void> deleteAllData() async {
    await _db.transaction(() async {
      for (final table in _db.allTables.toList().reversed) {
        await _db.delete(table).go();
      }
    });
    // Rebuild the file so no deleted content remains in free pages.
    await _db.customStatement('VACUUM');
    await _paths.deleteAll();
  }
}
