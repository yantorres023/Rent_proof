import 'package:drift/drift.dart';

import '../services/clock.dart';
import '../services/storage_paths.dart';
import 'database.dart';

class PropertyInput {
  const PropertyInput({
    required this.nickname,
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.region = '',
    this.postalCode = '',
    this.country = '',
    this.landlordName = '',
    this.leaseStart,
    this.notes = '',
  });

  final String nickname;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String region;
  final String postalCode;
  final String country;
  final String landlordName;
  final DateTime? leaseStart;
  final String notes;
}

class ValidationException implements Exception {
  const ValidationException(this.field, this.message);

  final String field;
  final String message;

  @override
  String toString() => 'ValidationException($field: $message)';
}

class PropertySummary {
  const PropertySummary({
    required this.property,
    required this.inspectionCount,
    this.lastInspectionAt,
  });

  final Property property;
  final int inspectionCount;
  final DateTime? lastInspectionAt;
}

String _clean(String s, int max) {
  final t = s.trim();
  return t.length > max ? t.substring(0, max) : t;
}

class PropertyRepository {
  PropertyRepository(
    this._db,
    this._paths, {
    Clock clock = const SystemClock(),
    IdGenerator ids = const IdGenerator(),
  }) : _clock = clock,
       _ids = ids;

  final AppDatabase _db;
  final StoragePaths _paths;
  final Clock _clock;
  final IdGenerator _ids;

  PropertiesCompanion _companion(PropertyInput input) {
    final nickname = _clean(input.nickname, 120);
    if (nickname.isEmpty) {
      throw const ValidationException('nickname', 'required');
    }
    return PropertiesCompanion(
      nickname: Value(nickname),
      addressLine1: Value(_clean(input.addressLine1, 200)),
      addressLine2: Value(_clean(input.addressLine2, 200)),
      city: Value(_clean(input.city, 100)),
      region: Value(_clean(input.region, 100)),
      postalCode: Value(_clean(input.postalCode, 20)),
      country: Value(_clean(input.country, 60)),
      landlordName: Value(_clean(input.landlordName, 120)),
      leaseStart: Value(input.leaseStart),
      notes: Value(_clean(input.notes, 2000)),
    );
  }

  Future<Property> create(PropertyInput input) async {
    final now = _clock.now();
    final id = _ids.next();
    await _db
        .into(_db.properties)
        .insert(
          _companion(input).copyWith(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return get(id);
  }

  Future<Property> update(String id, PropertyInput input) async {
    await (_db.update(_db.properties)..where((t) => t.id.equals(id))).write(
      _companion(input).copyWith(updatedAt: Value(_clock.now())),
    );
    return get(id);
  }

  Future<Property> get(String id) =>
      (_db.select(_db.properties)..where((t) => t.id.equals(id))).getSingle();

  Stream<Property?> watch(String id) => (_db.select(
    _db.properties,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<PropertySummary>> watchSummaries() {
    final count = _db.inspections.id.count();
    final last = _db.inspections.startedAt.max();
    final query =
        _db.select(_db.properties).join([
            leftOuterJoin(
              _db.inspections,
              _db.inspections.propertyId.equalsExp(_db.properties.id),
            ),
          ])
          ..addColumns([count, last])
          ..groupBy([_db.properties.id])
          ..orderBy([OrderingTerm.desc(_db.properties.updatedAt)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          PropertySummary(
            property: r.readTable(_db.properties),
            inspectionCount: r.read(count) ?? 0,
            lastInspectionAt: r.read(last),
          ),
      ],
    );
  }

  /// Deletes the property, its inspections and every stored file.
  Future<void> delete(String id) async {
    final inspectionIds =
        await (_db.selectOnly(_db.inspections)
              ..addColumns([_db.inspections.id])
              ..where(_db.inspections.propertyId.equals(id)))
            .map((r) => r.read(_db.inspections.id)!)
            .get();
    await (_db.delete(_db.properties)..where((t) => t.id.equals(id))).go();
    for (final inspectionId in inspectionIds) {
      await _paths.deleteInspectionFiles(inspectionId);
    }
  }

  Future<void> touch(String id) async {
    await (_db.update(_db.properties)..where((t) => t.id.equals(id))).write(
      PropertiesCompanion(updatedAt: Value(_clock.now())),
    );
  }
}
