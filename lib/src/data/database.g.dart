// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayName, email, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String displayName;
  final String email;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['email'] = Variable<String>(email);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      email: Value(email),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      email: serializer.fromJson<String>(json['email']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'email': serializer.toJson<String>(email),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? displayName,
    String? email,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    email: email ?? this.email,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, email, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> email;
  final Value<DateTime> updatedAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String>? email,
    Value<DateTime>? updatedAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, Property> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _postalCodeMeta = const VerificationMeta(
    'postalCode',
  );
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
    'postal_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _landlordNameMeta = const VerificationMeta(
    'landlordName',
  );
  @override
  late final GeneratedColumn<String> landlordName = GeneratedColumn<String>(
    'landlord_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _leaseStartMeta = const VerificationMeta(
    'leaseStart',
  );
  @override
  late final GeneratedColumn<DateTime> leaseStart = GeneratedColumn<DateTime>(
    'lease_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickname,
    addressLine1,
    addressLine2,
    city,
    region,
    postalCode,
    country,
    landlordName,
    leaseStart,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Property> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('postal_code')) {
      context.handle(
        _postalCodeMeta,
        postalCode.isAcceptableOrUnknown(data['postal_code']!, _postalCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('landlord_name')) {
      context.handle(
        _landlordNameMeta,
        landlordName.isAcceptableOrUnknown(
          data['landlord_name']!,
          _landlordNameMeta,
        ),
      );
    }
    if (data.containsKey('lease_start')) {
      context.handle(
        _leaseStartMeta,
        leaseStart.isAcceptableOrUnknown(data['lease_start']!, _leaseStartMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Property map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Property(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      )!,
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      postalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      landlordName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landlord_name'],
      )!,
      leaseStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lease_start'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }
}

class Property extends DataClass implements Insertable<Property> {
  final String id;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  const Property({
    required this.id,
    required this.nickname,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.country,
    required this.landlordName,
    this.leaseStart,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nickname'] = Variable<String>(nickname);
    map['address_line1'] = Variable<String>(addressLine1);
    map['address_line2'] = Variable<String>(addressLine2);
    map['city'] = Variable<String>(city);
    map['region'] = Variable<String>(region);
    map['postal_code'] = Variable<String>(postalCode);
    map['country'] = Variable<String>(country);
    map['landlord_name'] = Variable<String>(landlordName);
    if (!nullToAbsent || leaseStart != null) {
      map['lease_start'] = Variable<DateTime>(leaseStart);
    }
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      addressLine1: Value(addressLine1),
      addressLine2: Value(addressLine2),
      city: Value(city),
      region: Value(region),
      postalCode: Value(postalCode),
      country: Value(country),
      landlordName: Value(landlordName),
      leaseStart: leaseStart == null && nullToAbsent
          ? const Value.absent()
          : Value(leaseStart),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Property.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Property(
      id: serializer.fromJson<String>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      addressLine1: serializer.fromJson<String>(json['addressLine1']),
      addressLine2: serializer.fromJson<String>(json['addressLine2']),
      city: serializer.fromJson<String>(json['city']),
      region: serializer.fromJson<String>(json['region']),
      postalCode: serializer.fromJson<String>(json['postalCode']),
      country: serializer.fromJson<String>(json['country']),
      landlordName: serializer.fromJson<String>(json['landlordName']),
      leaseStart: serializer.fromJson<DateTime?>(json['leaseStart']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nickname': serializer.toJson<String>(nickname),
      'addressLine1': serializer.toJson<String>(addressLine1),
      'addressLine2': serializer.toJson<String>(addressLine2),
      'city': serializer.toJson<String>(city),
      'region': serializer.toJson<String>(region),
      'postalCode': serializer.toJson<String>(postalCode),
      'country': serializer.toJson<String>(country),
      'landlordName': serializer.toJson<String>(landlordName),
      'leaseStart': serializer.toJson<DateTime?>(leaseStart),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Property copyWith({
    String? id,
    String? nickname,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? region,
    String? postalCode,
    String? country,
    String? landlordName,
    Value<DateTime?> leaseStart = const Value.absent(),
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Property(
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    addressLine1: addressLine1 ?? this.addressLine1,
    addressLine2: addressLine2 ?? this.addressLine2,
    city: city ?? this.city,
    region: region ?? this.region,
    postalCode: postalCode ?? this.postalCode,
    country: country ?? this.country,
    landlordName: landlordName ?? this.landlordName,
    leaseStart: leaseStart.present ? leaseStart.value : this.leaseStart,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Property copyWithCompanion(PropertiesCompanion data) {
    return Property(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      region: data.region.present ? data.region.value : this.region,
      postalCode: data.postalCode.present
          ? data.postalCode.value
          : this.postalCode,
      country: data.country.present ? data.country.value : this.country,
      landlordName: data.landlordName.present
          ? data.landlordName.value
          : this.landlordName,
      leaseStart: data.leaseStart.present
          ? data.leaseStart.value
          : this.leaseStart,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Property(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('region: $region, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('landlordName: $landlordName, ')
          ..write('leaseStart: $leaseStart, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nickname,
    addressLine1,
    addressLine2,
    city,
    region,
    postalCode,
    country,
    landlordName,
    leaseStart,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Property &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.region == this.region &&
          other.postalCode == this.postalCode &&
          other.country == this.country &&
          other.landlordName == this.landlordName &&
          other.leaseStart == this.leaseStart &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PropertiesCompanion extends UpdateCompanion<Property> {
  final Value<String> id;
  final Value<String> nickname;
  final Value<String> addressLine1;
  final Value<String> addressLine2;
  final Value<String> city;
  final Value<String> region;
  final Value<String> postalCode;
  final Value<String> country;
  final Value<String> landlordName;
  final Value<DateTime?> leaseStart;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.region = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.landlordName = const Value.absent(),
    this.leaseStart = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesCompanion.insert({
    required String id,
    required String nickname,
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.region = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.landlordName = const Value.absent(),
    this.leaseStart = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nickname = Value(nickname),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Property> custom({
    Expression<String>? id,
    Expression<String>? nickname,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? region,
    Expression<String>? postalCode,
    Expression<String>? country,
    Expression<String>? landlordName,
    Expression<DateTime>? leaseStart,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (region != null) 'region': region,
      if (postalCode != null) 'postal_code': postalCode,
      if (country != null) 'country': country,
      if (landlordName != null) 'landlord_name': landlordName,
      if (leaseStart != null) 'lease_start': leaseStart,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesCompanion copyWith({
    Value<String>? id,
    Value<String>? nickname,
    Value<String>? addressLine1,
    Value<String>? addressLine2,
    Value<String>? city,
    Value<String>? region,
    Value<String>? postalCode,
    Value<String>? country,
    Value<String>? landlordName,
    Value<DateTime?>? leaseStart,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      landlordName: landlordName ?? this.landlordName,
      leaseStart: leaseStart ?? this.leaseStart,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (landlordName.present) {
      map['landlord_name'] = Variable<String>(landlordName.value);
    }
    if (leaseStart.present) {
      map['lease_start'] = Variable<DateTime>(leaseStart.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('region: $region, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('landlordName: $landlordName, ')
          ..write('leaseStart: $leaseStart, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InspectionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionType>($InspectionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<InspectionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionStatus>($InspectionsTable.$converterstatus);
  static const VerificationMeta _baselineInspectionIdMeta =
      const VerificationMeta('baselineInspectionId');
  @override
  late final GeneratedColumn<String> baselineInspectionId =
      GeneratedColumn<String>(
        'baseline_inspection_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES inspections (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPackageExportAtMeta =
      const VerificationMeta('lastPackageExportAt');
  @override
  late final GeneratedColumn<DateTime> lastPackageExportAt =
      GeneratedColumn<DateTime>(
        'last_package_export_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    type,
    status,
    baselineInspectionId,
    notes,
    startedAt,
    completedAt,
    lastPackageExportAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('baseline_inspection_id')) {
      context.handle(
        _baselineInspectionIdMeta,
        baselineInspectionId.isAcceptableOrUnknown(
          data['baseline_inspection_id']!,
          _baselineInspectionIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_package_export_at')) {
      context.handle(
        _lastPackageExportAtMeta,
        lastPackageExportAt.isAcceptableOrUnknown(
          data['last_package_export_at']!,
          _lastPackageExportAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      type: $InspectionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $InspectionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      baselineInspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baseline_inspection_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      lastPackageExportAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_package_export_at'],
      ),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InspectionType, String, String> $convertertype =
      const EnumNameConverter<InspectionType>(InspectionType.values);
  static JsonTypeConverter2<InspectionStatus, String, String> $converterstatus =
      const EnumNameConverter<InspectionStatus>(InspectionStatus.values);
}

class Inspection extends DataClass implements Insertable<Inspection> {
  final String id;
  final String propertyId;
  final InspectionType type;
  final InspectionStatus status;

  /// Earlier inspection of the same property used for comparison.
  final String? baselineInspectionId;
  final String notes;
  final DateTime startedAt;
  final DateTime? completedAt;

  /// Last time the user exported the evidence package (backup reminder).
  final DateTime? lastPackageExportAt;
  const Inspection({
    required this.id,
    required this.propertyId,
    required this.type,
    required this.status,
    this.baselineInspectionId,
    required this.notes,
    required this.startedAt,
    this.completedAt,
    this.lastPackageExportAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['property_id'] = Variable<String>(propertyId);
    {
      map['type'] = Variable<String>(
        $InspectionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || baselineInspectionId != null) {
      map['baseline_inspection_id'] = Variable<String>(baselineInspectionId);
    }
    map['notes'] = Variable<String>(notes);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || lastPackageExportAt != null) {
      map['last_package_export_at'] = Variable<DateTime>(lastPackageExportAt);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      type: Value(type),
      status: Value(status),
      baselineInspectionId: baselineInspectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineInspectionId),
      notes: Value(notes),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastPackageExportAt: lastPackageExportAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPackageExportAt),
    );
  }

  factory Inspection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<String>(json['id']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      type: $InspectionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      status: $InspectionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      baselineInspectionId: serializer.fromJson<String?>(
        json['baselineInspectionId'],
      ),
      notes: serializer.fromJson<String>(json['notes']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastPackageExportAt: serializer.fromJson<DateTime?>(
        json['lastPackageExportAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'propertyId': serializer.toJson<String>(propertyId),
      'type': serializer.toJson<String>(
        $InspectionsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<String>(
        $InspectionsTable.$converterstatus.toJson(status),
      ),
      'baselineInspectionId': serializer.toJson<String?>(baselineInspectionId),
      'notes': serializer.toJson<String>(notes),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastPackageExportAt': serializer.toJson<DateTime?>(lastPackageExportAt),
    };
  }

  Inspection copyWith({
    String? id,
    String? propertyId,
    InspectionType? type,
    InspectionStatus? status,
    Value<String?> baselineInspectionId = const Value.absent(),
    String? notes,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> lastPackageExportAt = const Value.absent(),
  }) => Inspection(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    type: type ?? this.type,
    status: status ?? this.status,
    baselineInspectionId: baselineInspectionId.present
        ? baselineInspectionId.value
        : this.baselineInspectionId,
    notes: notes ?? this.notes,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    lastPackageExportAt: lastPackageExportAt.present
        ? lastPackageExportAt.value
        : this.lastPackageExportAt,
  );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      baselineInspectionId: data.baselineInspectionId.present
          ? data.baselineInspectionId.value
          : this.baselineInspectionId,
      notes: data.notes.present ? data.notes.value : this.notes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      lastPackageExportAt: data.lastPackageExportAt.present
          ? data.lastPackageExportAt.value
          : this.lastPackageExportAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('baselineInspectionId: $baselineInspectionId, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastPackageExportAt: $lastPackageExportAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propertyId,
    type,
    status,
    baselineInspectionId,
    notes,
    startedAt,
    completedAt,
    lastPackageExportAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.type == this.type &&
          other.status == this.status &&
          other.baselineInspectionId == this.baselineInspectionId &&
          other.notes == this.notes &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.lastPackageExportAt == this.lastPackageExportAt);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<InspectionType> type;
  final Value<InspectionStatus> status;
  final Value<String?> baselineInspectionId;
  final Value<String> notes;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> lastPackageExportAt;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.baselineInspectionId = const Value.absent(),
    this.notes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastPackageExportAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required String propertyId,
    required InspectionType type,
    required InspectionStatus status,
    this.baselineInspectionId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.lastPackageExportAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       type = Value(type),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<Inspection> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? baselineInspectionId,
    Expression<String>? notes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? lastPackageExportAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (baselineInspectionId != null)
        'baseline_inspection_id': baselineInspectionId,
      if (notes != null) 'notes': notes,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastPackageExportAt != null)
        'last_package_export_at': lastPackageExportAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<InspectionType>? type,
    Value<InspectionStatus>? status,
    Value<String?>? baselineInspectionId,
    Value<String>? notes,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? lastPackageExportAt,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      status: status ?? this.status,
      baselineInspectionId: baselineInspectionId ?? this.baselineInspectionId,
      notes: notes ?? this.notes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastPackageExportAt: lastPackageExportAt ?? this.lastPackageExportAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $InspectionsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (baselineInspectionId.present) {
      map['baseline_inspection_id'] = Variable<String>(
        baselineInspectionId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastPackageExportAt.present) {
      map['last_package_export_at'] = Variable<DateTime>(
        lastPackageExportAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('baselineInspectionId: $baselineInspectionId, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastPackageExportAt: $lastPackageExportAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateKeyMeta = const VerificationMeta(
    'templateKey',
  );
  @override
  late final GeneratedColumn<String> templateKey = GeneratedColumn<String>(
    'template_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('custom'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoomStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RoomStatus>($RoomsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _baselineRoomIdMeta = const VerificationMeta(
    'baselineRoomId',
  );
  @override
  late final GeneratedColumn<String> baselineRoomId = GeneratedColumn<String>(
    'baseline_room_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    name,
    templateKey,
    position,
    status,
    notes,
    baselineRoomId,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Room> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('template_key')) {
      context.handle(
        _templateKeyMeta,
        templateKey.isAcceptableOrUnknown(
          data['template_key']!,
          _templateKeyMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('baseline_room_id')) {
      context.handle(
        _baselineRoomIdMeta,
        baselineRoomId.isAcceptableOrUnknown(
          data['baseline_room_id']!,
          _baselineRoomIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      templateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_key'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      status: $RoomsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      baselineRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baseline_room_id'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoomStatus, String, String> $converterstatus =
      const EnumNameConverter<RoomStatus>(RoomStatus.values);
}

class Room extends DataClass implements Insertable<Room> {
  final String id;
  final String inspectionId;
  final String name;

  /// Key of the room template used to create this room (e.g. `kitchen`).
  final String templateKey;
  final int position;
  final RoomStatus status;
  final String notes;

  /// Matching room in the baseline inspection, if any.
  final String? baselineRoomId;
  final DateTime? completedAt;
  const Room({
    required this.id,
    required this.inspectionId,
    required this.name,
    required this.templateKey,
    required this.position,
    required this.status,
    required this.notes,
    this.baselineRoomId,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['name'] = Variable<String>(name);
    map['template_key'] = Variable<String>(templateKey);
    map['position'] = Variable<int>(position);
    {
      map['status'] = Variable<String>(
        $RoomsTable.$converterstatus.toSql(status),
      );
    }
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || baselineRoomId != null) {
      map['baseline_room_id'] = Variable<String>(baselineRoomId);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      name: Value(name),
      templateKey: Value(templateKey),
      position: Value(position),
      status: Value(status),
      notes: Value(notes),
      baselineRoomId: baselineRoomId == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineRoomId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Room.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      name: serializer.fromJson<String>(json['name']),
      templateKey: serializer.fromJson<String>(json['templateKey']),
      position: serializer.fromJson<int>(json['position']),
      status: $RoomsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      notes: serializer.fromJson<String>(json['notes']),
      baselineRoomId: serializer.fromJson<String?>(json['baselineRoomId']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'name': serializer.toJson<String>(name),
      'templateKey': serializer.toJson<String>(templateKey),
      'position': serializer.toJson<int>(position),
      'status': serializer.toJson<String>(
        $RoomsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String>(notes),
      'baselineRoomId': serializer.toJson<String?>(baselineRoomId),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  Room copyWith({
    String? id,
    String? inspectionId,
    String? name,
    String? templateKey,
    int? position,
    RoomStatus? status,
    String? notes,
    Value<String?> baselineRoomId = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => Room(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    name: name ?? this.name,
    templateKey: templateKey ?? this.templateKey,
    position: position ?? this.position,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    baselineRoomId: baselineRoomId.present
        ? baselineRoomId.value
        : this.baselineRoomId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Room copyWithCompanion(RoomsCompanion data) {
    return Room(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      name: data.name.present ? data.name.value : this.name,
      templateKey: data.templateKey.present
          ? data.templateKey.value
          : this.templateKey,
      position: data.position.present ? data.position.value : this.position,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      baselineRoomId: data.baselineRoomId.present
          ? data.baselineRoomId.value
          : this.baselineRoomId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('name: $name, ')
          ..write('templateKey: $templateKey, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('baselineRoomId: $baselineRoomId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    name,
    templateKey,
    position,
    status,
    notes,
    baselineRoomId,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.name == this.name &&
          other.templateKey == this.templateKey &&
          other.position == this.position &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.baselineRoomId == this.baselineRoomId &&
          other.completedAt == this.completedAt);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String> name;
  final Value<String> templateKey;
  final Value<int> position;
  final Value<RoomStatus> status;
  final Value<String> notes;
  final Value<String?> baselineRoomId;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.name = const Value.absent(),
    this.templateKey = const Value.absent(),
    this.position = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.baselineRoomId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String id,
    required String inspectionId,
    required String name,
    this.templateKey = const Value.absent(),
    required int position,
    required RoomStatus status,
    this.notes = const Value.absent(),
    this.baselineRoomId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inspectionId = Value(inspectionId),
       name = Value(name),
       position = Value(position),
       status = Value(status);
  static Insertable<Room> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? name,
    Expression<String>? templateKey,
    Expression<int>? position,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? baselineRoomId,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (name != null) 'name': name,
      if (templateKey != null) 'template_key': templateKey,
      if (position != null) 'position': position,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (baselineRoomId != null) 'baseline_room_id': baselineRoomId,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith({
    Value<String>? id,
    Value<String>? inspectionId,
    Value<String>? name,
    Value<String>? templateKey,
    Value<int>? position,
    Value<RoomStatus>? status,
    Value<String>? notes,
    Value<String?>? baselineRoomId,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      name: name ?? this.name,
      templateKey: templateKey ?? this.templateKey,
      position: position ?? this.position,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      baselineRoomId: baselineRoomId ?? this.baselineRoomId,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (templateKey.present) {
      map['template_key'] = Variable<String>(templateKey.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RoomsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (baselineRoomId.present) {
      map['baseline_room_id'] = Variable<String>(baselineRoomId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('name: $name, ')
          ..write('templateKey: $templateKey, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('baselineRoomId: $baselineRoomId, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notApplicableMeta = const VerificationMeta(
    'notApplicable',
  );
  @override
  late final GeneratedColumn<bool> notApplicable = GeneratedColumn<bool>(
    'not_applicable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("not_applicable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    label,
    position,
    notApplicable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('not_applicable')) {
      context.handle(
        _notApplicableMeta,
        notApplicable.isAcceptableOrUnknown(
          data['not_applicable']!,
          _notApplicableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      notApplicable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}not_applicable'],
      )!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final String roomId;
  final String label;
  final int position;

  /// The user marked this prompt as not present in the unit.
  final bool notApplicable;
  const ChecklistItem({
    required this.id,
    required this.roomId,
    required this.label,
    required this.position,
    required this.notApplicable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    map['label'] = Variable<String>(label);
    map['position'] = Variable<int>(position);
    map['not_applicable'] = Variable<bool>(notApplicable);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      roomId: Value(roomId),
      label: Value(label),
      position: Value(position),
      notApplicable: Value(notApplicable),
    );
  }

  factory ChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      label: serializer.fromJson<String>(json['label']),
      position: serializer.fromJson<int>(json['position']),
      notApplicable: serializer.fromJson<bool>(json['notApplicable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'label': serializer.toJson<String>(label),
      'position': serializer.toJson<int>(position),
      'notApplicable': serializer.toJson<bool>(notApplicable),
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? roomId,
    String? label,
    int? position,
    bool? notApplicable,
  }) => ChecklistItem(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    label: label ?? this.label,
    position: position ?? this.position,
    notApplicable: notApplicable ?? this.notApplicable,
  );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      label: data.label.present ? data.label.value : this.label,
      position: data.position.present ? data.position.value : this.position,
      notApplicable: data.notApplicable.present
          ? data.notApplicable.value
          : this.notApplicable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('label: $label, ')
          ..write('position: $position, ')
          ..write('notApplicable: $notApplicable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, roomId, label, position, notApplicable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.label == this.label &&
          other.position == this.position &&
          other.notApplicable == this.notApplicable);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String> label;
  final Value<int> position;
  final Value<bool> notApplicable;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.label = const Value.absent(),
    this.position = const Value.absent(),
    this.notApplicable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String roomId,
    required String label,
    required int position,
    this.notApplicable = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       label = Value(label),
       position = Value(position);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? label,
    Expression<int>? position,
    Expression<bool>? notApplicable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (label != null) 'label': label,
      if (position != null) 'position': position,
      if (notApplicable != null) 'not_applicable': notApplicable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String>? label,
    Value<int>? position,
    Value<bool>? notApplicable,
    Value<int>? rowid,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      label: label ?? this.label,
      position: position ?? this.position,
      notApplicable: notApplicable ?? this.notApplicable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (notApplicable.present) {
      map['not_applicable'] = Variable<bool>(notApplicable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('label: $label, ')
          ..write('position: $position, ')
          ..write('notApplicable: $notApplicable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaEvidenceTable extends MediaEvidence
    with TableInfo<$MediaEvidenceTable, MediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaEvidenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _checklistItemIdMeta = const VerificationMeta(
    'checklistItemId',
  );
  @override
  late final GeneratedColumn<String> checklistItemId = GeneratedColumn<String>(
    'checklist_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES checklist_items (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaKind>($MediaEvidenceTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<MediaSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaSource>($MediaEvidenceTable.$convertersource);
  static const VerificationMeta _originalPathMeta = const VerificationMeta(
    'originalPath',
  );
  @override
  late final GeneratedColumn<String> originalPath = GeneratedColumn<String>(
    'original_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previewPathMeta = const VerificationMeta(
    'previewPath',
  );
  @override
  late final GeneratedColumn<String> previewPath = GeneratedColumn<String>(
    'preview_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceFileNameMeta = const VerificationMeta(
    'sourceFileName',
  );
  @override
  late final GeneratedColumn<String> sourceFileName = GeneratedColumn<String>(
    'source_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 64,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exifDateTimeOriginalMeta =
      const VerificationMeta('exifDateTimeOriginal');
  @override
  late final GeneratedColumn<String> exifDateTimeOriginal =
      GeneratedColumn<String>(
        'exif_date_time_original',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exifMakeMeta = const VerificationMeta(
    'exifMake',
  );
  @override
  late final GeneratedColumn<String> exifMake = GeneratedColumn<String>(
    'exif_make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exifModelMeta = const VerificationMeta(
    'exifModel',
  );
  @override
  late final GeneratedColumn<String> exifModel = GeneratedColumn<String>(
    'exif_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalHasGpsMeta = const VerificationMeta(
    'originalHasGps',
  );
  @override
  late final GeneratedColumn<bool> originalHasGps = GeneratedColumn<bool>(
    'original_has_gps',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("original_has_gps" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    checklistItemId,
    kind,
    source,
    originalPath,
    previewPath,
    thumbnailPath,
    sourceFileName,
    mimeType,
    byteSize,
    sha256,
    recordedAt,
    exifDateTimeOriginal,
    exifMake,
    exifModel,
    originalHasGps,
    width,
    height,
    caption,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('checklist_item_id')) {
      context.handle(
        _checklistItemIdMeta,
        checklistItemId.isAcceptableOrUnknown(
          data['checklist_item_id']!,
          _checklistItemIdMeta,
        ),
      );
    }
    if (data.containsKey('original_path')) {
      context.handle(
        _originalPathMeta,
        originalPath.isAcceptableOrUnknown(
          data['original_path']!,
          _originalPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPathMeta);
    }
    if (data.containsKey('preview_path')) {
      context.handle(
        _previewPathMeta,
        previewPath.isAcceptableOrUnknown(
          data['preview_path']!,
          _previewPathMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('source_file_name')) {
      context.handle(
        _sourceFileNameMeta,
        sourceFileName.isAcceptableOrUnknown(
          data['source_file_name']!,
          _sourceFileNameMeta,
        ),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('exif_date_time_original')) {
      context.handle(
        _exifDateTimeOriginalMeta,
        exifDateTimeOriginal.isAcceptableOrUnknown(
          data['exif_date_time_original']!,
          _exifDateTimeOriginalMeta,
        ),
      );
    }
    if (data.containsKey('exif_make')) {
      context.handle(
        _exifMakeMeta,
        exifMake.isAcceptableOrUnknown(data['exif_make']!, _exifMakeMeta),
      );
    }
    if (data.containsKey('exif_model')) {
      context.handle(
        _exifModelMeta,
        exifModel.isAcceptableOrUnknown(data['exif_model']!, _exifModelMeta),
      );
    }
    if (data.containsKey('original_has_gps')) {
      context.handle(
        _originalHasGpsMeta,
        originalHasGps.isAcceptableOrUnknown(
          data['original_has_gps']!,
          _originalHasGpsMeta,
        ),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      checklistItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist_item_id'],
      ),
      kind: $MediaEvidenceTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      source: $MediaEvidenceTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      originalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_path'],
      )!,
      previewPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preview_path'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      sourceFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      exifDateTimeOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exif_date_time_original'],
      ),
      exifMake: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exif_make'],
      ),
      exifModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exif_model'],
      ),
      originalHasGps: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}original_has_gps'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      )!,
    );
  }

  @override
  $MediaEvidenceTable createAlias(String alias) {
    return $MediaEvidenceTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaKind, String, String> $converterkind =
      const EnumNameConverter<MediaKind>(MediaKind.values);
  static JsonTypeConverter2<MediaSource, String, String> $convertersource =
      const EnumNameConverter<MediaSource>(MediaSource.values);
}

class MediaItem extends DataClass implements Insertable<MediaItem> {
  final String id;
  final String roomId;
  final String? checklistItemId;
  final MediaKind kind;
  final MediaSource source;

  /// Path of the stored original, relative to the evidence root directory.
  final String originalPath;

  /// Derived, downscaled copies (relative paths). Null if not derivable.
  final String? previewPath;
  final String? thumbnailPath;

  /// File name as provided by the OS picker/camera (sanitized).
  final String sourceFileName;
  final String mimeType;
  final int byteSize;

  /// Lowercase hex SHA-256 of the stored original at storage time.
  final String sha256;

  /// When the app received and stored the file (device clock).
  final DateTime recordedAt;

  /// Raw EXIF DateTimeOriginal as reported by the file, if any. Unverified.
  final String? exifDateTimeOriginal;
  final String? exifMake;
  final String? exifModel;

  /// Whether the original file contains GPS metadata (values not stored).
  final bool originalHasGps;
  final int? width;
  final int? height;
  final String caption;
  const MediaItem({
    required this.id,
    required this.roomId,
    this.checklistItemId,
    required this.kind,
    required this.source,
    required this.originalPath,
    this.previewPath,
    this.thumbnailPath,
    required this.sourceFileName,
    required this.mimeType,
    required this.byteSize,
    required this.sha256,
    required this.recordedAt,
    this.exifDateTimeOriginal,
    this.exifMake,
    this.exifModel,
    required this.originalHasGps,
    this.width,
    this.height,
    required this.caption,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    if (!nullToAbsent || checklistItemId != null) {
      map['checklist_item_id'] = Variable<String>(checklistItemId);
    }
    {
      map['kind'] = Variable<String>(
        $MediaEvidenceTable.$converterkind.toSql(kind),
      );
    }
    {
      map['source'] = Variable<String>(
        $MediaEvidenceTable.$convertersource.toSql(source),
      );
    }
    map['original_path'] = Variable<String>(originalPath);
    if (!nullToAbsent || previewPath != null) {
      map['preview_path'] = Variable<String>(previewPath);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['source_file_name'] = Variable<String>(sourceFileName);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    map['sha256'] = Variable<String>(sha256);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || exifDateTimeOriginal != null) {
      map['exif_date_time_original'] = Variable<String>(exifDateTimeOriginal);
    }
    if (!nullToAbsent || exifMake != null) {
      map['exif_make'] = Variable<String>(exifMake);
    }
    if (!nullToAbsent || exifModel != null) {
      map['exif_model'] = Variable<String>(exifModel);
    }
    map['original_has_gps'] = Variable<bool>(originalHasGps);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['caption'] = Variable<String>(caption);
    return map;
  }

  MediaEvidenceCompanion toCompanion(bool nullToAbsent) {
    return MediaEvidenceCompanion(
      id: Value(id),
      roomId: Value(roomId),
      checklistItemId: checklistItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(checklistItemId),
      kind: Value(kind),
      source: Value(source),
      originalPath: Value(originalPath),
      previewPath: previewPath == null && nullToAbsent
          ? const Value.absent()
          : Value(previewPath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      sourceFileName: Value(sourceFileName),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      sha256: Value(sha256),
      recordedAt: Value(recordedAt),
      exifDateTimeOriginal: exifDateTimeOriginal == null && nullToAbsent
          ? const Value.absent()
          : Value(exifDateTimeOriginal),
      exifMake: exifMake == null && nullToAbsent
          ? const Value.absent()
          : Value(exifMake),
      exifModel: exifModel == null && nullToAbsent
          ? const Value.absent()
          : Value(exifModel),
      originalHasGps: Value(originalHasGps),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      caption: Value(caption),
    );
  }

  factory MediaItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaItem(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      checklistItemId: serializer.fromJson<String?>(json['checklistItemId']),
      kind: $MediaEvidenceTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      source: $MediaEvidenceTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      originalPath: serializer.fromJson<String>(json['originalPath']),
      previewPath: serializer.fromJson<String?>(json['previewPath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      sourceFileName: serializer.fromJson<String>(json['sourceFileName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      sha256: serializer.fromJson<String>(json['sha256']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      exifDateTimeOriginal: serializer.fromJson<String?>(
        json['exifDateTimeOriginal'],
      ),
      exifMake: serializer.fromJson<String?>(json['exifMake']),
      exifModel: serializer.fromJson<String?>(json['exifModel']),
      originalHasGps: serializer.fromJson<bool>(json['originalHasGps']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      caption: serializer.fromJson<String>(json['caption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'checklistItemId': serializer.toJson<String?>(checklistItemId),
      'kind': serializer.toJson<String>(
        $MediaEvidenceTable.$converterkind.toJson(kind),
      ),
      'source': serializer.toJson<String>(
        $MediaEvidenceTable.$convertersource.toJson(source),
      ),
      'originalPath': serializer.toJson<String>(originalPath),
      'previewPath': serializer.toJson<String?>(previewPath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'sourceFileName': serializer.toJson<String>(sourceFileName),
      'mimeType': serializer.toJson<String>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'sha256': serializer.toJson<String>(sha256),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'exifDateTimeOriginal': serializer.toJson<String?>(exifDateTimeOriginal),
      'exifMake': serializer.toJson<String?>(exifMake),
      'exifModel': serializer.toJson<String?>(exifModel),
      'originalHasGps': serializer.toJson<bool>(originalHasGps),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'caption': serializer.toJson<String>(caption),
    };
  }

  MediaItem copyWith({
    String? id,
    String? roomId,
    Value<String?> checklistItemId = const Value.absent(),
    MediaKind? kind,
    MediaSource? source,
    String? originalPath,
    Value<String?> previewPath = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    String? sourceFileName,
    String? mimeType,
    int? byteSize,
    String? sha256,
    DateTime? recordedAt,
    Value<String?> exifDateTimeOriginal = const Value.absent(),
    Value<String?> exifMake = const Value.absent(),
    Value<String?> exifModel = const Value.absent(),
    bool? originalHasGps,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    String? caption,
  }) => MediaItem(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    checklistItemId: checklistItemId.present
        ? checklistItemId.value
        : this.checklistItemId,
    kind: kind ?? this.kind,
    source: source ?? this.source,
    originalPath: originalPath ?? this.originalPath,
    previewPath: previewPath.present ? previewPath.value : this.previewPath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    sourceFileName: sourceFileName ?? this.sourceFileName,
    mimeType: mimeType ?? this.mimeType,
    byteSize: byteSize ?? this.byteSize,
    sha256: sha256 ?? this.sha256,
    recordedAt: recordedAt ?? this.recordedAt,
    exifDateTimeOriginal: exifDateTimeOriginal.present
        ? exifDateTimeOriginal.value
        : this.exifDateTimeOriginal,
    exifMake: exifMake.present ? exifMake.value : this.exifMake,
    exifModel: exifModel.present ? exifModel.value : this.exifModel,
    originalHasGps: originalHasGps ?? this.originalHasGps,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    caption: caption ?? this.caption,
  );
  MediaItem copyWithCompanion(MediaEvidenceCompanion data) {
    return MediaItem(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      checklistItemId: data.checklistItemId.present
          ? data.checklistItemId.value
          : this.checklistItemId,
      kind: data.kind.present ? data.kind.value : this.kind,
      source: data.source.present ? data.source.value : this.source,
      originalPath: data.originalPath.present
          ? data.originalPath.value
          : this.originalPath,
      previewPath: data.previewPath.present
          ? data.previewPath.value
          : this.previewPath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      sourceFileName: data.sourceFileName.present
          ? data.sourceFileName.value
          : this.sourceFileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      exifDateTimeOriginal: data.exifDateTimeOriginal.present
          ? data.exifDateTimeOriginal.value
          : this.exifDateTimeOriginal,
      exifMake: data.exifMake.present ? data.exifMake.value : this.exifMake,
      exifModel: data.exifModel.present ? data.exifModel.value : this.exifModel,
      originalHasGps: data.originalHasGps.present
          ? data.originalHasGps.value
          : this.originalHasGps,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      caption: data.caption.present ? data.caption.value : this.caption,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaItem(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('checklistItemId: $checklistItemId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('originalPath: $originalPath, ')
          ..write('previewPath: $previewPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('sourceFileName: $sourceFileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('sha256: $sha256, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('exifDateTimeOriginal: $exifDateTimeOriginal, ')
          ..write('exifMake: $exifMake, ')
          ..write('exifModel: $exifModel, ')
          ..write('originalHasGps: $originalHasGps, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomId,
    checklistItemId,
    kind,
    source,
    originalPath,
    previewPath,
    thumbnailPath,
    sourceFileName,
    mimeType,
    byteSize,
    sha256,
    recordedAt,
    exifDateTimeOriginal,
    exifMake,
    exifModel,
    originalHasGps,
    width,
    height,
    caption,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaItem &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.checklistItemId == this.checklistItemId &&
          other.kind == this.kind &&
          other.source == this.source &&
          other.originalPath == this.originalPath &&
          other.previewPath == this.previewPath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.sourceFileName == this.sourceFileName &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.sha256 == this.sha256 &&
          other.recordedAt == this.recordedAt &&
          other.exifDateTimeOriginal == this.exifDateTimeOriginal &&
          other.exifMake == this.exifMake &&
          other.exifModel == this.exifModel &&
          other.originalHasGps == this.originalHasGps &&
          other.width == this.width &&
          other.height == this.height &&
          other.caption == this.caption);
}

class MediaEvidenceCompanion extends UpdateCompanion<MediaItem> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String?> checklistItemId;
  final Value<MediaKind> kind;
  final Value<MediaSource> source;
  final Value<String> originalPath;
  final Value<String?> previewPath;
  final Value<String?> thumbnailPath;
  final Value<String> sourceFileName;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<String> sha256;
  final Value<DateTime> recordedAt;
  final Value<String?> exifDateTimeOriginal;
  final Value<String?> exifMake;
  final Value<String?> exifModel;
  final Value<bool> originalHasGps;
  final Value<int?> width;
  final Value<int?> height;
  final Value<String> caption;
  final Value<int> rowid;
  const MediaEvidenceCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.checklistItemId = const Value.absent(),
    this.kind = const Value.absent(),
    this.source = const Value.absent(),
    this.originalPath = const Value.absent(),
    this.previewPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.sourceFileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.exifDateTimeOriginal = const Value.absent(),
    this.exifMake = const Value.absent(),
    this.exifModel = const Value.absent(),
    this.originalHasGps = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.caption = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaEvidenceCompanion.insert({
    required String id,
    required String roomId,
    this.checklistItemId = const Value.absent(),
    required MediaKind kind,
    required MediaSource source,
    required String originalPath,
    this.previewPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.sourceFileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    required int byteSize,
    required String sha256,
    required DateTime recordedAt,
    this.exifDateTimeOriginal = const Value.absent(),
    this.exifMake = const Value.absent(),
    this.exifModel = const Value.absent(),
    this.originalHasGps = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.caption = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       kind = Value(kind),
       source = Value(source),
       originalPath = Value(originalPath),
       byteSize = Value(byteSize),
       sha256 = Value(sha256),
       recordedAt = Value(recordedAt);
  static Insertable<MediaItem> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? checklistItemId,
    Expression<String>? kind,
    Expression<String>? source,
    Expression<String>? originalPath,
    Expression<String>? previewPath,
    Expression<String>? thumbnailPath,
    Expression<String>? sourceFileName,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<String>? sha256,
    Expression<DateTime>? recordedAt,
    Expression<String>? exifDateTimeOriginal,
    Expression<String>? exifMake,
    Expression<String>? exifModel,
    Expression<bool>? originalHasGps,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? caption,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (checklistItemId != null) 'checklist_item_id': checklistItemId,
      if (kind != null) 'kind': kind,
      if (source != null) 'source': source,
      if (originalPath != null) 'original_path': originalPath,
      if (previewPath != null) 'preview_path': previewPath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (sourceFileName != null) 'source_file_name': sourceFileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (sha256 != null) 'sha256': sha256,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (exifDateTimeOriginal != null)
        'exif_date_time_original': exifDateTimeOriginal,
      if (exifMake != null) 'exif_make': exifMake,
      if (exifModel != null) 'exif_model': exifModel,
      if (originalHasGps != null) 'original_has_gps': originalHasGps,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (caption != null) 'caption': caption,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaEvidenceCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String?>? checklistItemId,
    Value<MediaKind>? kind,
    Value<MediaSource>? source,
    Value<String>? originalPath,
    Value<String?>? previewPath,
    Value<String?>? thumbnailPath,
    Value<String>? sourceFileName,
    Value<String>? mimeType,
    Value<int>? byteSize,
    Value<String>? sha256,
    Value<DateTime>? recordedAt,
    Value<String?>? exifDateTimeOriginal,
    Value<String?>? exifMake,
    Value<String?>? exifModel,
    Value<bool>? originalHasGps,
    Value<int?>? width,
    Value<int?>? height,
    Value<String>? caption,
    Value<int>? rowid,
  }) {
    return MediaEvidenceCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      checklistItemId: checklistItemId ?? this.checklistItemId,
      kind: kind ?? this.kind,
      source: source ?? this.source,
      originalPath: originalPath ?? this.originalPath,
      previewPath: previewPath ?? this.previewPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      sourceFileName: sourceFileName ?? this.sourceFileName,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      sha256: sha256 ?? this.sha256,
      recordedAt: recordedAt ?? this.recordedAt,
      exifDateTimeOriginal: exifDateTimeOriginal ?? this.exifDateTimeOriginal,
      exifMake: exifMake ?? this.exifMake,
      exifModel: exifModel ?? this.exifModel,
      originalHasGps: originalHasGps ?? this.originalHasGps,
      width: width ?? this.width,
      height: height ?? this.height,
      caption: caption ?? this.caption,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (checklistItemId.present) {
      map['checklist_item_id'] = Variable<String>(checklistItemId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $MediaEvidenceTable.$converterkind.toSql(kind.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $MediaEvidenceTable.$convertersource.toSql(source.value),
      );
    }
    if (originalPath.present) {
      map['original_path'] = Variable<String>(originalPath.value);
    }
    if (previewPath.present) {
      map['preview_path'] = Variable<String>(previewPath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (sourceFileName.present) {
      map['source_file_name'] = Variable<String>(sourceFileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (exifDateTimeOriginal.present) {
      map['exif_date_time_original'] = Variable<String>(
        exifDateTimeOriginal.value,
      );
    }
    if (exifMake.present) {
      map['exif_make'] = Variable<String>(exifMake.value);
    }
    if (exifModel.present) {
      map['exif_model'] = Variable<String>(exifModel.value);
    }
    if (originalHasGps.present) {
      map['original_has_gps'] = Variable<bool>(originalHasGps.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaEvidenceCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('checklistItemId: $checklistItemId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('originalPath: $originalPath, ')
          ..write('previewPath: $previewPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('sourceFileName: $sourceFileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('sha256: $sha256, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('exifDateTimeOriginal: $exifDateTimeOriginal, ')
          ..write('exifMake: $exifMake, ')
          ..write('exifModel: $exifModel, ')
          ..write('originalHasGps: $originalHasGps, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('caption: $caption, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceHashesTable extends EvidenceHashes
    with TableInfo<$EvidenceHashesTable, EvidenceHash> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceHashesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_evidence (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _algorithmMeta = const VerificationMeta(
    'algorithm',
  );
  @override
  late final GeneratedColumn<String> algorithm = GeneratedColumn<String>(
    'algorithm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SHA-256'),
  );
  static const VerificationMeta _hexDigestMeta = const VerificationMeta(
    'hexDigest',
  );
  @override
  late final GeneratedColumn<String> hexDigest = GeneratedColumn<String>(
    'hex_digest',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HashPurpose, String> purpose =
      GeneratedColumn<String>(
        'purpose',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HashPurpose>($EvidenceHashesTable.$converterpurpose);
  @override
  late final GeneratedColumnWithTypeConverter<HashCheckResult, String> result =
      GeneratedColumn<String>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HashCheckResult>($EvidenceHashesTable.$converterresult);
  static const VerificationMeta _computedAtMeta = const VerificationMeta(
    'computedAt',
  );
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
    'computed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mediaId,
    algorithm,
    hexDigest,
    purpose,
    result,
    computedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence_hashes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceHash> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('algorithm')) {
      context.handle(
        _algorithmMeta,
        algorithm.isAcceptableOrUnknown(data['algorithm']!, _algorithmMeta),
      );
    }
    if (data.containsKey('hex_digest')) {
      context.handle(
        _hexDigestMeta,
        hexDigest.isAcceptableOrUnknown(data['hex_digest']!, _hexDigestMeta),
      );
    }
    if (data.containsKey('computed_at')) {
      context.handle(
        _computedAtMeta,
        computedAt.isAcceptableOrUnknown(data['computed_at']!, _computedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceHash map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceHash(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      algorithm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm'],
      )!,
      hexDigest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hex_digest'],
      ),
      purpose: $EvidenceHashesTable.$converterpurpose.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}purpose'],
        )!,
      ),
      result: $EvidenceHashesTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        )!,
      ),
      computedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}computed_at'],
      )!,
    );
  }

  @override
  $EvidenceHashesTable createAlias(String alias) {
    return $EvidenceHashesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HashPurpose, String, String> $converterpurpose =
      const EnumNameConverter<HashPurpose>(HashPurpose.values);
  static JsonTypeConverter2<HashCheckResult, String, String> $converterresult =
      const EnumNameConverter<HashCheckResult>(HashCheckResult.values);
}

class EvidenceHash extends DataClass implements Insertable<EvidenceHash> {
  final String id;
  final String mediaId;
  final String algorithm;
  final String? hexDigest;
  final HashPurpose purpose;
  final HashCheckResult result;
  final DateTime computedAt;
  const EvidenceHash({
    required this.id,
    required this.mediaId,
    required this.algorithm,
    this.hexDigest,
    required this.purpose,
    required this.result,
    required this.computedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['media_id'] = Variable<String>(mediaId);
    map['algorithm'] = Variable<String>(algorithm);
    if (!nullToAbsent || hexDigest != null) {
      map['hex_digest'] = Variable<String>(hexDigest);
    }
    {
      map['purpose'] = Variable<String>(
        $EvidenceHashesTable.$converterpurpose.toSql(purpose),
      );
    }
    {
      map['result'] = Variable<String>(
        $EvidenceHashesTable.$converterresult.toSql(result),
      );
    }
    map['computed_at'] = Variable<DateTime>(computedAt);
    return map;
  }

  EvidenceHashesCompanion toCompanion(bool nullToAbsent) {
    return EvidenceHashesCompanion(
      id: Value(id),
      mediaId: Value(mediaId),
      algorithm: Value(algorithm),
      hexDigest: hexDigest == null && nullToAbsent
          ? const Value.absent()
          : Value(hexDigest),
      purpose: Value(purpose),
      result: Value(result),
      computedAt: Value(computedAt),
    );
  }

  factory EvidenceHash.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceHash(
      id: serializer.fromJson<String>(json['id']),
      mediaId: serializer.fromJson<String>(json['mediaId']),
      algorithm: serializer.fromJson<String>(json['algorithm']),
      hexDigest: serializer.fromJson<String?>(json['hexDigest']),
      purpose: $EvidenceHashesTable.$converterpurpose.fromJson(
        serializer.fromJson<String>(json['purpose']),
      ),
      result: $EvidenceHashesTable.$converterresult.fromJson(
        serializer.fromJson<String>(json['result']),
      ),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mediaId': serializer.toJson<String>(mediaId),
      'algorithm': serializer.toJson<String>(algorithm),
      'hexDigest': serializer.toJson<String?>(hexDigest),
      'purpose': serializer.toJson<String>(
        $EvidenceHashesTable.$converterpurpose.toJson(purpose),
      ),
      'result': serializer.toJson<String>(
        $EvidenceHashesTable.$converterresult.toJson(result),
      ),
      'computedAt': serializer.toJson<DateTime>(computedAt),
    };
  }

  EvidenceHash copyWith({
    String? id,
    String? mediaId,
    String? algorithm,
    Value<String?> hexDigest = const Value.absent(),
    HashPurpose? purpose,
    HashCheckResult? result,
    DateTime? computedAt,
  }) => EvidenceHash(
    id: id ?? this.id,
    mediaId: mediaId ?? this.mediaId,
    algorithm: algorithm ?? this.algorithm,
    hexDigest: hexDigest.present ? hexDigest.value : this.hexDigest,
    purpose: purpose ?? this.purpose,
    result: result ?? this.result,
    computedAt: computedAt ?? this.computedAt,
  );
  EvidenceHash copyWithCompanion(EvidenceHashesCompanion data) {
    return EvidenceHash(
      id: data.id.present ? data.id.value : this.id,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      algorithm: data.algorithm.present ? data.algorithm.value : this.algorithm,
      hexDigest: data.hexDigest.present ? data.hexDigest.value : this.hexDigest,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      result: data.result.present ? data.result.value : this.result,
      computedAt: data.computedAt.present
          ? data.computedAt.value
          : this.computedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceHash(')
          ..write('id: $id, ')
          ..write('mediaId: $mediaId, ')
          ..write('algorithm: $algorithm, ')
          ..write('hexDigest: $hexDigest, ')
          ..write('purpose: $purpose, ')
          ..write('result: $result, ')
          ..write('computedAt: $computedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mediaId,
    algorithm,
    hexDigest,
    purpose,
    result,
    computedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceHash &&
          other.id == this.id &&
          other.mediaId == this.mediaId &&
          other.algorithm == this.algorithm &&
          other.hexDigest == this.hexDigest &&
          other.purpose == this.purpose &&
          other.result == this.result &&
          other.computedAt == this.computedAt);
}

class EvidenceHashesCompanion extends UpdateCompanion<EvidenceHash> {
  final Value<String> id;
  final Value<String> mediaId;
  final Value<String> algorithm;
  final Value<String?> hexDigest;
  final Value<HashPurpose> purpose;
  final Value<HashCheckResult> result;
  final Value<DateTime> computedAt;
  final Value<int> rowid;
  const EvidenceHashesCompanion({
    this.id = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.algorithm = const Value.absent(),
    this.hexDigest = const Value.absent(),
    this.purpose = const Value.absent(),
    this.result = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceHashesCompanion.insert({
    required String id,
    required String mediaId,
    this.algorithm = const Value.absent(),
    this.hexDigest = const Value.absent(),
    required HashPurpose purpose,
    required HashCheckResult result,
    required DateTime computedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mediaId = Value(mediaId),
       purpose = Value(purpose),
       result = Value(result),
       computedAt = Value(computedAt);
  static Insertable<EvidenceHash> custom({
    Expression<String>? id,
    Expression<String>? mediaId,
    Expression<String>? algorithm,
    Expression<String>? hexDigest,
    Expression<String>? purpose,
    Expression<String>? result,
    Expression<DateTime>? computedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mediaId != null) 'media_id': mediaId,
      if (algorithm != null) 'algorithm': algorithm,
      if (hexDigest != null) 'hex_digest': hexDigest,
      if (purpose != null) 'purpose': purpose,
      if (result != null) 'result': result,
      if (computedAt != null) 'computed_at': computedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceHashesCompanion copyWith({
    Value<String>? id,
    Value<String>? mediaId,
    Value<String>? algorithm,
    Value<String?>? hexDigest,
    Value<HashPurpose>? purpose,
    Value<HashCheckResult>? result,
    Value<DateTime>? computedAt,
    Value<int>? rowid,
  }) {
    return EvidenceHashesCompanion(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      algorithm: algorithm ?? this.algorithm,
      hexDigest: hexDigest ?? this.hexDigest,
      purpose: purpose ?? this.purpose,
      result: result ?? this.result,
      computedAt: computedAt ?? this.computedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (algorithm.present) {
      map['algorithm'] = Variable<String>(algorithm.value);
    }
    if (hexDigest.present) {
      map['hex_digest'] = Variable<String>(hexDigest.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(
        $EvidenceHashesTable.$converterpurpose.toSql(purpose.value),
      );
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $EvidenceHashesTable.$converterresult.toSql(result.value),
      );
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceHashesCompanion(')
          ..write('id: $id, ')
          ..write('mediaId: $mediaId, ')
          ..write('algorithm: $algorithm, ')
          ..write('hexDigest: $hexDigest, ')
          ..write('purpose: $purpose, ')
          ..write('result: $result, ')
          ..write('computedAt: $computedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IssuesTable extends Issues with TableInfo<$IssuesTable, Issue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IssuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_evidence (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<IssueCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IssueCategory>($IssuesTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<IssueSeverity, String> severity =
      GeneratedColumn<String>(
        'severity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IssueSeverity>($IssuesTable.$converterseverity);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    mediaId,
    title,
    description,
    category,
    severity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'issues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Issue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Issue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Issue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: $IssuesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      severity: $IssuesTable.$converterseverity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}severity'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IssuesTable createAlias(String alias) {
    return $IssuesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IssueCategory, String, String> $convertercategory =
      const EnumNameConverter<IssueCategory>(IssueCategory.values);
  static JsonTypeConverter2<IssueSeverity, String, String> $converterseverity =
      const EnumNameConverter<IssueSeverity>(IssueSeverity.values);
}

class Issue extends DataClass implements Insertable<Issue> {
  final String id;
  final String roomId;

  /// Photo that shows the issue, if any.
  final String? mediaId;
  final String title;
  final String description;
  final IssueCategory category;
  final IssueSeverity severity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Issue({
    required this.id,
    required this.roomId,
    this.mediaId,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    if (!nullToAbsent || mediaId != null) {
      map['media_id'] = Variable<String>(mediaId);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['category'] = Variable<String>(
        $IssuesTable.$convertercategory.toSql(category),
      );
    }
    {
      map['severity'] = Variable<String>(
        $IssuesTable.$converterseverity.toSql(severity),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IssuesCompanion toCompanion(bool nullToAbsent) {
    return IssuesCompanion(
      id: Value(id),
      roomId: Value(roomId),
      mediaId: mediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaId),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      severity: Value(severity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Issue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Issue(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      mediaId: serializer.fromJson<String?>(json['mediaId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: $IssuesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      severity: $IssuesTable.$converterseverity.fromJson(
        serializer.fromJson<String>(json['severity']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'mediaId': serializer.toJson<String?>(mediaId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(
        $IssuesTable.$convertercategory.toJson(category),
      ),
      'severity': serializer.toJson<String>(
        $IssuesTable.$converterseverity.toJson(severity),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Issue copyWith({
    String? id,
    String? roomId,
    Value<String?> mediaId = const Value.absent(),
    String? title,
    String? description,
    IssueCategory? category,
    IssueSeverity? severity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Issue(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    mediaId: mediaId.present ? mediaId.value : this.mediaId,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    severity: severity ?? this.severity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Issue copyWithCompanion(IssuesCompanion data) {
    return Issue(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Issue(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('mediaId: $mediaId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomId,
    mediaId,
    title,
    description,
    category,
    severity,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Issue &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.mediaId == this.mediaId &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IssuesCompanion extends UpdateCompanion<Issue> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String?> mediaId;
  final Value<String> title;
  final Value<String> description;
  final Value<IssueCategory> category;
  final Value<IssueSeverity> severity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IssuesCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IssuesCompanion.insert({
    required String id,
    required String roomId,
    this.mediaId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required IssueCategory category,
    required IssueSeverity severity,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       title = Value(title),
       category = Value(category),
       severity = Value(severity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Issue> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? mediaId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? severity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (mediaId != null) 'media_id': mediaId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IssuesCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String?>? mediaId,
    Value<String>? title,
    Value<String>? description,
    Value<IssueCategory>? category,
    Value<IssueSeverity>? severity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IssuesCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      mediaId: mediaId ?? this.mediaId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $IssuesTable.$convertercategory.toSql(category.value),
      );
    }
    if (severity.present) {
      map['severity'] = Variable<String>(
        $IssuesTable.$converterseverity.toSql(severity.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IssuesCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('mediaId: $mediaId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTable extends Annotations
    with TableInfo<$AnnotationsTable, Annotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_evidence (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _issueIdMeta = const VerificationMeta(
    'issueId',
  );
  @override
  late final GeneratedColumn<String> issueId = GeneratedColumn<String>(
    'issue_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES issues (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mediaId,
    issueId,
    x,
    y,
    label,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Annotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('issue_id')) {
      context.handle(
        _issueIdMeta,
        issueId.isAcceptableOrUnknown(data['issue_id']!, _issueIdMeta),
      );
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Annotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Annotation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      issueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue_id'],
      ),
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AnnotationsTable createAlias(String alias) {
    return $AnnotationsTable(attachedDatabase, alias);
  }
}

class Annotation extends DataClass implements Insertable<Annotation> {
  final String id;
  final String mediaId;
  final String? issueId;

  /// Normalized position (0..1) relative to the displayed image.
  final double x;
  final double y;
  final String label;
  final DateTime createdAt;
  const Annotation({
    required this.id,
    required this.mediaId,
    this.issueId,
    required this.x,
    required this.y,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['media_id'] = Variable<String>(mediaId);
    if (!nullToAbsent || issueId != null) {
      map['issue_id'] = Variable<String>(issueId);
    }
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AnnotationsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsCompanion(
      id: Value(id),
      mediaId: Value(mediaId),
      issueId: issueId == null && nullToAbsent
          ? const Value.absent()
          : Value(issueId),
      x: Value(x),
      y: Value(y),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory Annotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Annotation(
      id: serializer.fromJson<String>(json['id']),
      mediaId: serializer.fromJson<String>(json['mediaId']),
      issueId: serializer.fromJson<String?>(json['issueId']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mediaId': serializer.toJson<String>(mediaId),
      'issueId': serializer.toJson<String?>(issueId),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Annotation copyWith({
    String? id,
    String? mediaId,
    Value<String?> issueId = const Value.absent(),
    double? x,
    double? y,
    String? label,
    DateTime? createdAt,
  }) => Annotation(
    id: id ?? this.id,
    mediaId: mediaId ?? this.mediaId,
    issueId: issueId.present ? issueId.value : this.issueId,
    x: x ?? this.x,
    y: y ?? this.y,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  Annotation copyWithCompanion(AnnotationsCompanion data) {
    return Annotation(
      id: data.id.present ? data.id.value : this.id,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      issueId: data.issueId.present ? data.issueId.value : this.issueId,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Annotation(')
          ..write('id: $id, ')
          ..write('mediaId: $mediaId, ')
          ..write('issueId: $issueId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mediaId, issueId, x, y, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Annotation &&
          other.id == this.id &&
          other.mediaId == this.mediaId &&
          other.issueId == this.issueId &&
          other.x == this.x &&
          other.y == this.y &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class AnnotationsCompanion extends UpdateCompanion<Annotation> {
  final Value<String> id;
  final Value<String> mediaId;
  final Value<String?> issueId;
  final Value<double> x;
  final Value<double> y;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AnnotationsCompanion({
    this.id = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.issueId = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnotationsCompanion.insert({
    required String id,
    required String mediaId,
    this.issueId = const Value.absent(),
    required double x,
    required double y,
    this.label = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mediaId = Value(mediaId),
       x = Value(x),
       y = Value(y),
       createdAt = Value(createdAt);
  static Insertable<Annotation> custom({
    Expression<String>? id,
    Expression<String>? mediaId,
    Expression<String>? issueId,
    Expression<double>? x,
    Expression<double>? y,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mediaId != null) 'media_id': mediaId,
      if (issueId != null) 'issue_id': issueId,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnotationsCompanion copyWith({
    Value<String>? id,
    Value<String>? mediaId,
    Value<String?>? issueId,
    Value<double>? x,
    Value<double>? y,
    Value<String>? label,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AnnotationsCompanion(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      issueId: issueId ?? this.issueId,
      x: x ?? this.x,
      y: y ?? this.y,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (issueId.present) {
      map['issue_id'] = Variable<String>(issueId.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsCompanion(')
          ..write('id: $id, ')
          ..write('mediaId: $mediaId, ')
          ..write('issueId: $issueId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsTable extends Reports with TableInfo<$ReportsTable, Report> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 64,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaCountMeta = const VerificationMeta(
    'mediaCount',
  );
  @override
  late final GeneratedColumn<int> mediaCount = GeneratedColumn<int>(
    'media_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issueCountMeta = const VerificationMeta(
    'issueCount',
  );
  @override
  late final GeneratedColumn<int> issueCount = GeneratedColumn<int>(
    'issue_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _includesComparisonMeta =
      const VerificationMeta('includesComparison');
  @override
  late final GeneratedColumn<bool> includesComparison = GeneratedColumn<bool>(
    'includes_comparison',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("includes_comparison" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentToLandlordAtMeta = const VerificationMeta(
    'sentToLandlordAt',
  );
  @override
  late final GeneratedColumn<DateTime> sentToLandlordAt =
      GeneratedColumn<DateTime>(
        'sent_to_landlord_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    filePath,
    sha256,
    byteSize,
    mediaCount,
    issueCount,
    includesComparison,
    generatedAt,
    sentToLandlordAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<Report> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('media_count')) {
      context.handle(
        _mediaCountMeta,
        mediaCount.isAcceptableOrUnknown(data['media_count']!, _mediaCountMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaCountMeta);
    }
    if (data.containsKey('issue_count')) {
      context.handle(
        _issueCountMeta,
        issueCount.isAcceptableOrUnknown(data['issue_count']!, _issueCountMeta),
      );
    } else if (isInserting) {
      context.missing(_issueCountMeta);
    }
    if (data.containsKey('includes_comparison')) {
      context.handle(
        _includesComparisonMeta,
        includesComparison.isAcceptableOrUnknown(
          data['includes_comparison']!,
          _includesComparisonMeta,
        ),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('sent_to_landlord_at')) {
      context.handle(
        _sentToLandlordAtMeta,
        sentToLandlordAt.isAcceptableOrUnknown(
          data['sent_to_landlord_at']!,
          _sentToLandlordAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Report map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Report(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      mediaCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_count'],
      )!,
      issueCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}issue_count'],
      )!,
      includesComparison: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}includes_comparison'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      sentToLandlordAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_to_landlord_at'],
      ),
    );
  }

  @override
  $ReportsTable createAlias(String alias) {
    return $ReportsTable(attachedDatabase, alias);
  }
}

class Report extends DataClass implements Insertable<Report> {
  final String id;
  final String inspectionId;

  /// Path relative to the reports root directory.
  final String filePath;
  final String sha256;
  final int byteSize;
  final int mediaCount;
  final int issueCount;
  final bool includesComparison;
  final DateTime generatedAt;

  /// When the user confirmed they sent this report to the landlord/manager.
  /// Self-reported; the email provider's sent record is the stronger proof.
  final DateTime? sentToLandlordAt;
  const Report({
    required this.id,
    required this.inspectionId,
    required this.filePath,
    required this.sha256,
    required this.byteSize,
    required this.mediaCount,
    required this.issueCount,
    required this.includesComparison,
    required this.generatedAt,
    this.sentToLandlordAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspection_id'] = Variable<String>(inspectionId);
    map['file_path'] = Variable<String>(filePath);
    map['sha256'] = Variable<String>(sha256);
    map['byte_size'] = Variable<int>(byteSize);
    map['media_count'] = Variable<int>(mediaCount);
    map['issue_count'] = Variable<int>(issueCount);
    map['includes_comparison'] = Variable<bool>(includesComparison);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || sentToLandlordAt != null) {
      map['sent_to_landlord_at'] = Variable<DateTime>(sentToLandlordAt);
    }
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      filePath: Value(filePath),
      sha256: Value(sha256),
      byteSize: Value(byteSize),
      mediaCount: Value(mediaCount),
      issueCount: Value(issueCount),
      includesComparison: Value(includesComparison),
      generatedAt: Value(generatedAt),
      sentToLandlordAt: sentToLandlordAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentToLandlordAt),
    );
  }

  factory Report.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Report(
      id: serializer.fromJson<String>(json['id']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      sha256: serializer.fromJson<String>(json['sha256']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      mediaCount: serializer.fromJson<int>(json['mediaCount']),
      issueCount: serializer.fromJson<int>(json['issueCount']),
      includesComparison: serializer.fromJson<bool>(json['includesComparison']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      sentToLandlordAt: serializer.fromJson<DateTime?>(
        json['sentToLandlordAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'filePath': serializer.toJson<String>(filePath),
      'sha256': serializer.toJson<String>(sha256),
      'byteSize': serializer.toJson<int>(byteSize),
      'mediaCount': serializer.toJson<int>(mediaCount),
      'issueCount': serializer.toJson<int>(issueCount),
      'includesComparison': serializer.toJson<bool>(includesComparison),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'sentToLandlordAt': serializer.toJson<DateTime?>(sentToLandlordAt),
    };
  }

  Report copyWith({
    String? id,
    String? inspectionId,
    String? filePath,
    String? sha256,
    int? byteSize,
    int? mediaCount,
    int? issueCount,
    bool? includesComparison,
    DateTime? generatedAt,
    Value<DateTime?> sentToLandlordAt = const Value.absent(),
  }) => Report(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    filePath: filePath ?? this.filePath,
    sha256: sha256 ?? this.sha256,
    byteSize: byteSize ?? this.byteSize,
    mediaCount: mediaCount ?? this.mediaCount,
    issueCount: issueCount ?? this.issueCount,
    includesComparison: includesComparison ?? this.includesComparison,
    generatedAt: generatedAt ?? this.generatedAt,
    sentToLandlordAt: sentToLandlordAt.present
        ? sentToLandlordAt.value
        : this.sentToLandlordAt,
  );
  Report copyWithCompanion(ReportsCompanion data) {
    return Report(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      mediaCount: data.mediaCount.present
          ? data.mediaCount.value
          : this.mediaCount,
      issueCount: data.issueCount.present
          ? data.issueCount.value
          : this.issueCount,
      includesComparison: data.includesComparison.present
          ? data.includesComparison.value
          : this.includesComparison,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      sentToLandlordAt: data.sentToLandlordAt.present
          ? data.sentToLandlordAt.value
          : this.sentToLandlordAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Report(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('filePath: $filePath, ')
          ..write('sha256: $sha256, ')
          ..write('byteSize: $byteSize, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('issueCount: $issueCount, ')
          ..write('includesComparison: $includesComparison, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('sentToLandlordAt: $sentToLandlordAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    filePath,
    sha256,
    byteSize,
    mediaCount,
    issueCount,
    includesComparison,
    generatedAt,
    sentToLandlordAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.filePath == this.filePath &&
          other.sha256 == this.sha256 &&
          other.byteSize == this.byteSize &&
          other.mediaCount == this.mediaCount &&
          other.issueCount == this.issueCount &&
          other.includesComparison == this.includesComparison &&
          other.generatedAt == this.generatedAt &&
          other.sentToLandlordAt == this.sentToLandlordAt);
}

class ReportsCompanion extends UpdateCompanion<Report> {
  final Value<String> id;
  final Value<String> inspectionId;
  final Value<String> filePath;
  final Value<String> sha256;
  final Value<int> byteSize;
  final Value<int> mediaCount;
  final Value<int> issueCount;
  final Value<bool> includesComparison;
  final Value<DateTime> generatedAt;
  final Value<DateTime?> sentToLandlordAt;
  final Value<int> rowid;
  const ReportsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.mediaCount = const Value.absent(),
    this.issueCount = const Value.absent(),
    this.includesComparison = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.sentToLandlordAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCompanion.insert({
    required String id,
    required String inspectionId,
    required String filePath,
    required String sha256,
    required int byteSize,
    required int mediaCount,
    required int issueCount,
    this.includesComparison = const Value.absent(),
    required DateTime generatedAt,
    this.sentToLandlordAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inspectionId = Value(inspectionId),
       filePath = Value(filePath),
       sha256 = Value(sha256),
       byteSize = Value(byteSize),
       mediaCount = Value(mediaCount),
       issueCount = Value(issueCount),
       generatedAt = Value(generatedAt);
  static Insertable<Report> custom({
    Expression<String>? id,
    Expression<String>? inspectionId,
    Expression<String>? filePath,
    Expression<String>? sha256,
    Expression<int>? byteSize,
    Expression<int>? mediaCount,
    Expression<int>? issueCount,
    Expression<bool>? includesComparison,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? sentToLandlordAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (filePath != null) 'file_path': filePath,
      if (sha256 != null) 'sha256': sha256,
      if (byteSize != null) 'byte_size': byteSize,
      if (mediaCount != null) 'media_count': mediaCount,
      if (issueCount != null) 'issue_count': issueCount,
      if (includesComparison != null) 'includes_comparison': includesComparison,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (sentToLandlordAt != null) 'sent_to_landlord_at': sentToLandlordAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? inspectionId,
    Value<String>? filePath,
    Value<String>? sha256,
    Value<int>? byteSize,
    Value<int>? mediaCount,
    Value<int>? issueCount,
    Value<bool>? includesComparison,
    Value<DateTime>? generatedAt,
    Value<DateTime?>? sentToLandlordAt,
    Value<int>? rowid,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      filePath: filePath ?? this.filePath,
      sha256: sha256 ?? this.sha256,
      byteSize: byteSize ?? this.byteSize,
      mediaCount: mediaCount ?? this.mediaCount,
      issueCount: issueCount ?? this.issueCount,
      includesComparison: includesComparison ?? this.includesComparison,
      generatedAt: generatedAt ?? this.generatedAt,
      sentToLandlordAt: sentToLandlordAt ?? this.sentToLandlordAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (mediaCount.present) {
      map['media_count'] = Variable<int>(mediaCount.value);
    }
    if (issueCount.present) {
      map['issue_count'] = Variable<int>(issueCount.value);
    }
    if (includesComparison.present) {
      map['includes_comparison'] = Variable<bool>(includesComparison.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (sentToLandlordAt.present) {
      map['sent_to_landlord_at'] = Variable<DateTime>(sentToLandlordAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('filePath: $filePath, ')
          ..write('sha256: $sha256, ')
          ..write('byteSize: $byteSize, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('issueCount: $issueCount, ')
          ..write('includesComparison: $includesComparison, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('sentToLandlordAt: $sentToLandlordAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomComparisonsTable extends RoomComparisons
    with TableInfo<$RoomComparisonsTable, RoomComparison> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomComparisonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ComparisonVerdict, String>
  verdict = GeneratedColumn<String>(
    'verdict',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ComparisonVerdict>($RoomComparisonsTable.$converterverdict);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, roomId, verdict, note, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_comparisons';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomComparison> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {roomId},
  ];
  @override
  RoomComparison map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomComparison(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      verdict: $RoomComparisonsTable.$converterverdict.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}verdict'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoomComparisonsTable createAlias(String alias) {
    return $RoomComparisonsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ComparisonVerdict, String, String>
  $converterverdict = const EnumNameConverter<ComparisonVerdict>(
    ComparisonVerdict.values,
  );
}

class RoomComparison extends DataClass implements Insertable<RoomComparison> {
  final String id;
  final String roomId;
  final ComparisonVerdict verdict;
  final String note;
  final DateTime updatedAt;
  const RoomComparison({
    required this.id,
    required this.roomId,
    required this.verdict,
    required this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    {
      map['verdict'] = Variable<String>(
        $RoomComparisonsTable.$converterverdict.toSql(verdict),
      );
    }
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoomComparisonsCompanion toCompanion(bool nullToAbsent) {
    return RoomComparisonsCompanion(
      id: Value(id),
      roomId: Value(roomId),
      verdict: Value(verdict),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoomComparison.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomComparison(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      verdict: $RoomComparisonsTable.$converterverdict.fromJson(
        serializer.fromJson<String>(json['verdict']),
      ),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'verdict': serializer.toJson<String>(
        $RoomComparisonsTable.$converterverdict.toJson(verdict),
      ),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoomComparison copyWith({
    String? id,
    String? roomId,
    ComparisonVerdict? verdict,
    String? note,
    DateTime? updatedAt,
  }) => RoomComparison(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    verdict: verdict ?? this.verdict,
    note: note ?? this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoomComparison copyWithCompanion(RoomComparisonsCompanion data) {
    return RoomComparison(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      verdict: data.verdict.present ? data.verdict.value : this.verdict,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomComparison(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('verdict: $verdict, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, roomId, verdict, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomComparison &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.verdict == this.verdict &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class RoomComparisonsCompanion extends UpdateCompanion<RoomComparison> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<ComparisonVerdict> verdict;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoomComparisonsCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.verdict = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomComparisonsCompanion.insert({
    required String id,
    required String roomId,
    required ComparisonVerdict verdict,
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       verdict = Value(verdict),
       updatedAt = Value(updatedAt);
  static Insertable<RoomComparison> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? verdict,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (verdict != null) 'verdict': verdict,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomComparisonsCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<ComparisonVerdict>? verdict,
    Value<String>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoomComparisonsCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      verdict: verdict ?? this.verdict,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (verdict.present) {
      map['verdict'] = Variable<String>(
        $RoomComparisonsTable.$converterverdict.toSql(verdict.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomComparisonsCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('verdict: $verdict, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $MediaEvidenceTable mediaEvidence = $MediaEvidenceTable(this);
  late final $EvidenceHashesTable evidenceHashes = $EvidenceHashesTable(this);
  late final $IssuesTable issues = $IssuesTable(this);
  late final $AnnotationsTable annotations = $AnnotationsTable(this);
  late final $ReportsTable reports = $ReportsTable(this);
  late final $RoomComparisonsTable roomComparisons = $RoomComparisonsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    appSettings,
    properties,
    inspections,
    rooms,
    checklistItems,
    mediaEvidence,
    evidenceHashes,
    issues,
    annotations,
    reports,
    roomComparisons,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'properties',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inspections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspections', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inspections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rooms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rooms', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('checklist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_evidence', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'checklist_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_evidence', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media_evidence',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evidence_hashes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('issues', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media_evidence',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('issues', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media_evidence',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('annotations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'issues',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('annotations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inspections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reports', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('room_comparisons', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> email,
      required DateTime updatedAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> email,
      Value<DateTime> updatedAt,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                email: email,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> email = const Value.absent(),
                required DateTime updatedAt,
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                email: email,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$PropertiesTableCreateCompanionBuilder = PropertiesCompanion Function({
  required String id,
  required String nickname,
  Value<String> addressLine1,
  Value<String> addressLine2,
  Value<String> city,
  Value<String> region,
  Value<String> postalCode,
  Value<String> country,
  Value<String> landlordName,
  Value<DateTime?> leaseStart,
  Value<String> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PropertiesTableUpdateCompanionBuilder = PropertiesCompanion Function({
  Value<String> id,
  Value<String> nickname,
  Value<String> addressLine1,
  Value<String> addressLine2,
  Value<String> city,
  Value<String> region,
  Value<String> postalCode,
  Value<String> country,
  Value<String> landlordName,
  Value<DateTime?> leaseStart,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PropertiesTableReferences
    extends BaseReferences<_$AppDatabase, $PropertiesTable, Property> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InspectionsTable, List<Inspection>>
  _inspectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspections,
    aliasName: 'properties__id__inspections__property_id',
  );

  $$InspectionsTableProcessedTableManager get inspectionsRefs {
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get leaseStart => $composableBuilder(
    column: $table.leaseStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inspectionsRefs(
    Expression<bool> Function($$InspectionsTableFilterComposer f) f,
  ) {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get leaseStart => $composableBuilder(
    column: $table.leaseStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get landlordName => $composableBuilder(
    column: $table.landlordName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get leaseStart => $composableBuilder(
    column: $table.leaseStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> inspectionsRefs<T extends Object>(
    Expression<T> Function($$InspectionsTableAnnotationComposer a) f,
  ) {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          Property,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (Property, $$PropertiesTableReferences),
          Property,
          PrefetchHooks Function({bool inspectionsRefs})
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> addressLine1 = const Value.absent(),
                Value<String> addressLine2 = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String> postalCode = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> landlordName = const Value.absent(),
                Value<DateTime?> leaseStart = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                nickname: nickname,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                region: region,
                postalCode: postalCode,
                country: country,
                landlordName: landlordName,
                leaseStart: leaseStart,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nickname,
                Value<String> addressLine1 = const Value.absent(),
                Value<String> addressLine2 = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String> postalCode = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> landlordName = const Value.absent(),
                Value<DateTime?> leaseStart = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                nickname: nickname,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                region: region,
                postalCode: postalCode,
                country: country,
                landlordName: landlordName,
                leaseStart: leaseStart,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropertiesTable, Property>(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (inspectionsRefs) db.inspections],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inspectionsRefs)
                    await $_getPrefetchedData<
                      Property,
                      $PropertiesTable,
                      Inspection
                    >(
                      currentTable: table,
                      referencedTable: $$PropertiesTableReferences
                          ._inspectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertiesTableReferences(
                            db,
                            table,
                            p0,
                          ).inspectionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.propertyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      Property,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (Property, $$PropertiesTableReferences),
      Property,
      PrefetchHooks Function({bool inspectionsRefs})
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String id,
      required String propertyId,
      required InspectionType type,
      required InspectionStatus status,
      Value<String?> baselineInspectionId,
      Value<String> notes,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> lastPackageExportAt,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<InspectionType> type,
      Value<InspectionStatus> status,
      Value<String?> baselineInspectionId,
      Value<String> notes,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> lastPackageExportAt,
      Value<int> rowid,
    });

final class $$InspectionsTableReferences
    extends BaseReferences<_$AppDatabase, $InspectionsTable, Inspection> {
  $$InspectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$AppDatabase db) =>
      db.properties.createAlias('inspections__property_id__properties__id');

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InspectionsTable _baselineInspectionIdTable(_$AppDatabase db) => db
      .inspections
      .createAlias('inspections__baseline_inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager? get baselineInspectionId {
    final $_column = $_itemColumn<String>('baseline_inspection_id');
    if ($_column == null) return null;
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _baselineInspectionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoomsTable, List<Room>> _roomsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rooms,
    aliasName: 'inspections__id__rooms__inspection_id',
  );

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReportsTable, List<Report>> _reportsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reports,
    aliasName: 'inspections__id__reports__inspection_id',
  );

  $$ReportsTableProcessedTableManager get reportsRefs {
    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionType, InspectionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionStatus, InspectionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPackageExportAt => $composableBuilder(
    column: $table.lastPackageExportAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableFilterComposer get baselineInspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> roomsRefs(
    Expression<bool> Function($$RoomsTableFilterComposer f) f,
  ) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reportsRefs(
    Expression<bool> Function($$ReportsTableFilterComposer f) f,
  ) {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPackageExportAt => $composableBuilder(
    column: $table.lastPackageExportAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableOrderingComposer get baselineInspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPackageExportAt => $composableBuilder(
    column: $table.lastPackageExportAt,
    builder: (column) => column,
  );

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableAnnotationComposer get baselineInspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineInspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> roomsRefs<T extends Object>(
    Expression<T> Function($$RoomsTableAnnotationComposer a) f,
  ) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reportsRefs<T extends Object>(
    Expression<T> Function($$ReportsTableAnnotationComposer a) f,
  ) {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (Inspection, $$InspectionsTableReferences),
          Inspection,
          PrefetchHooks Function({
            bool propertyId,
            bool baselineInspectionId,
            bool roomsRefs,
            bool reportsRefs,
          })
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<InspectionType> type = const Value.absent(),
                Value<InspectionStatus> status = const Value.absent(),
                Value<String?> baselineInspectionId = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> lastPackageExportAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                propertyId: propertyId,
                type: type,
                status: status,
                baselineInspectionId: baselineInspectionId,
                notes: notes,
                startedAt: startedAt,
                completedAt: completedAt,
                lastPackageExportAt: lastPackageExportAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required InspectionType type,
                required InspectionStatus status,
                Value<String?> baselineInspectionId = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> lastPackageExportAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                propertyId: propertyId,
                type: type,
                status: status,
                baselineInspectionId: baselineInspectionId,
                notes: notes,
                startedAt: startedAt,
                completedAt: completedAt,
                lastPackageExportAt: lastPackageExportAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionsTable, Inspection>(table),
                  $$InspectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propertyId = false,
                baselineInspectionId = false,
                roomsRefs = false,
                reportsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roomsRefs) db.rooms,
                    if (reportsRefs) db.reports,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.propertyId,
                            referencedTable: $$InspectionsTableReferences
                                ._propertyIdTable(db),
                            referencedColumn: $$InspectionsTableReferences
                                ._propertyIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (baselineInspectionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.baselineInspectionId,
                            referencedTable: $$InspectionsTableReferences
                                ._baselineInspectionIdTable(db),
                            referencedColumn: $$InspectionsTableReferences
                                ._baselineInspectionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (roomsRefs)
                        await $_getPrefetchedData<
                          Inspection,
                          $InspectionsTable,
                          Room
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._roomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).roomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reportsRefs)
                        await $_getPrefetchedData<
                          Inspection,
                          $InspectionsTable,
                          Report
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._reportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (Inspection, $$InspectionsTableReferences),
      Inspection,
      PrefetchHooks Function({
        bool propertyId,
        bool baselineInspectionId,
        bool roomsRefs,
        bool reportsRefs,
      })
    >;
typedef $$RoomsTableCreateCompanionBuilder = RoomsCompanion Function({
  required String id,
  required String inspectionId,
  required String name,
  Value<String> templateKey,
  required int position,
  required RoomStatus status,
  Value<String> notes,
  Value<String?> baselineRoomId,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$RoomsTableUpdateCompanionBuilder = RoomsCompanion Function({
  Value<String> id,
  Value<String> inspectionId,
  Value<String> name,
  Value<String> templateKey,
  Value<int> position,
  Value<RoomStatus> status,
  Value<String> notes,
  Value<String?> baselineRoomId,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$RoomsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomsTable, Room> {
  $$RoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias('rooms__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<String>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RoomsTable _baselineRoomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('rooms__baseline_room_id__rooms__id');

  $$RoomsTableProcessedTableManager? get baselineRoomId {
    final $_column = $_itemColumn<String>('baseline_room_id');
    if ($_column == null) return null;
    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baselineRoomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItem>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'rooms__id__checklist_items__room_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaEvidenceTable, List<MediaItem>>
  _mediaEvidenceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaEvidence,
    aliasName: 'rooms__id__media_evidence__room_id',
  );

  $$MediaEvidenceTableProcessedTableManager get mediaEvidenceRefs {
    final manager = $$MediaEvidenceTableTableManager(
      $_db,
      $_db.mediaEvidence,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaEvidenceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IssuesTable, List<Issue>> _issuesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.issues,
    aliasName: 'rooms__id__issues__room_id',
  );

  $$IssuesTableProcessedTableManager get issuesRefs {
    final manager = $$IssuesTableTableManager(
      $_db,
      $_db.issues,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_issuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoomComparisonsTable, List<RoomComparison>>
  _roomComparisonsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roomComparisons,
    aliasName: 'rooms__id__room_comparisons__room_id',
  );

  $$RoomComparisonsTableProcessedTableManager get roomComparisonsRefs {
    final manager = $$RoomComparisonsTableTableManager(
      $_db,
      $_db.roomComparisons,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _roomComparisonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoomStatus, RoomStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoomsTableFilterComposer get baselineRoomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineRoomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaEvidenceRefs(
    Expression<bool> Function($$MediaEvidenceTableFilterComposer f) f,
  ) {
    final $$MediaEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> issuesRefs(
    Expression<bool> Function($$IssuesTableFilterComposer f) f,
  ) {
    final $$IssuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableFilterComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roomComparisonsRefs(
    Expression<bool> Function($$RoomComparisonsTableFilterComposer f) f,
  ) {
    final $$RoomComparisonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomComparisons,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomComparisonsTableFilterComposer(
            $db: $db,
            $table: $db.roomComparisons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoomsTableOrderingComposer get baselineRoomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineRoomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoomStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoomsTableAnnotationComposer get baselineRoomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baselineRoomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mediaEvidenceRefs<T extends Object>(
    Expression<T> Function($$MediaEvidenceTableAnnotationComposer a) f,
  ) {
    final $$MediaEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> issuesRefs<T extends Object>(
    Expression<T> Function($$IssuesTableAnnotationComposer a) f,
  ) {
    final $$IssuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableAnnotationComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roomComparisonsRefs<T extends Object>(
    Expression<T> Function($$RoomComparisonsTableAnnotationComposer a) f,
  ) {
    final $$RoomComparisonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomComparisons,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomComparisonsTableAnnotationComposer(
            $db: $db,
            $table: $db.roomComparisons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          Room,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (Room, $$RoomsTableReferences),
          Room,
          PrefetchHooks Function({
            bool inspectionId,
            bool baselineRoomId,
            bool checklistItemsRefs,
            bool mediaEvidenceRefs,
            bool issuesRefs,
            bool roomComparisonsRefs,
          })
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> templateKey = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<RoomStatus> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> baselineRoomId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                inspectionId: inspectionId,
                name: name,
                templateKey: templateKey,
                position: position,
                status: status,
                notes: notes,
                baselineRoomId: baselineRoomId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inspectionId,
                required String name,
                Value<String> templateKey = const Value.absent(),
                required int position,
                required RoomStatus status,
                Value<String> notes = const Value.absent(),
                Value<String?> baselineRoomId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                name: name,
                templateKey: templateKey,
                position: position,
                status: status,
                notes: notes,
                baselineRoomId: baselineRoomId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomsTable, Room>(table),
                  $$RoomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inspectionId = false,
                baselineRoomId = false,
                checklistItemsRefs = false,
                mediaEvidenceRefs = false,
                issuesRefs = false,
                roomComparisonsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checklistItemsRefs) db.checklistItems,
                    if (mediaEvidenceRefs) db.mediaEvidence,
                    if (issuesRefs) db.issues,
                    if (roomComparisonsRefs) db.roomComparisons,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (inspectionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.inspectionId,
                            referencedTable: $$RoomsTableReferences
                                ._inspectionIdTable(db),
                            referencedColumn: $$RoomsTableReferences
                                ._inspectionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (baselineRoomId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.baselineRoomId,
                            referencedTable: $$RoomsTableReferences
                                ._baselineRoomIdTable(db),
                            referencedColumn: $$RoomsTableReferences
                                ._baselineRoomIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checklistItemsRefs)
                        await $_getPrefetchedData<
                          Room,
                          $RoomsTable,
                          ChecklistItem
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).checklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaEvidenceRefs)
                        await $_getPrefetchedData<Room, $RoomsTable, MediaItem>(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._mediaEvidenceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaEvidenceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (issuesRefs)
                        await $_getPrefetchedData<Room, $RoomsTable, Issue>(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._issuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(db, table, p0).issuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (roomComparisonsRefs)
                        await $_getPrefetchedData<
                          Room,
                          $RoomsTable,
                          RoomComparison
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._roomComparisonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).roomComparisonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      Room,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (Room, $$RoomsTableReferences),
      Room,
      PrefetchHooks Function({
        bool inspectionId,
        bool baselineRoomId,
        bool checklistItemsRefs,
        bool mediaEvidenceRefs,
        bool issuesRefs,
        bool roomComparisonsRefs,
      })
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      required String id,
      required String roomId,
      required String label,
      required int position,
      Value<bool> notApplicable,
      Value<int> rowid,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<String> id,
      Value<String> roomId,
      Value<String> label,
      Value<int> position,
      Value<bool> notApplicable,
      Value<int> rowid,
    });

final class $$ChecklistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem> {
  $$ChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('checklist_items__room_id__rooms__id');

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<String>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MediaEvidenceTable, List<MediaItem>>
  _mediaEvidenceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaEvidence,
    aliasName: 'checklist_items__id__media_evidence__checklist_item_id',
  );

  $$MediaEvidenceTableProcessedTableManager get mediaEvidenceRefs {
    final manager = $$MediaEvidenceTableTableManager($_db, $_db.mediaEvidence)
        .filter(
          (f) => f.checklistItemId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_mediaEvidenceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notApplicable => $composableBuilder(
    column: $table.notApplicable,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mediaEvidenceRefs(
    Expression<bool> Function($$MediaEvidenceTableFilterComposer f) f,
  ) {
    final $$MediaEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.checklistItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notApplicable => $composableBuilder(
    column: $table.notApplicable,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get notApplicable => $composableBuilder(
    column: $table.notApplicable,
    builder: (column) => column,
  );

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mediaEvidenceRefs<T extends Object>(
    Expression<T> Function($$MediaEvidenceTableAnnotationComposer a) f,
  ) {
    final $$MediaEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.checklistItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItem,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (ChecklistItem, $$ChecklistItemsTableReferences),
          ChecklistItem,
          PrefetchHooks Function({bool roomId, bool mediaEvidenceRefs})
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> notApplicable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                roomId: roomId,
                label: label,
                position: position,
                notApplicable: notApplicable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                required String label,
                required int position,
                Value<bool> notApplicable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion.insert(
                id: id,
                roomId: roomId,
                label: label,
                position: position,
                notApplicable: notApplicable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChecklistItemsTable, ChecklistItem>(table),
                  $$ChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomId = false, mediaEvidenceRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mediaEvidenceRefs) db.mediaEvidence,
              ],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (roomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.roomId,
                        referencedTable: $$ChecklistItemsTableReferences
                            ._roomIdTable(db),
                        referencedColumn: $$ChecklistItemsTableReferences
                            ._roomIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaEvidenceRefs)
                    await $_getPrefetchedData<
                      ChecklistItem,
                      $ChecklistItemsTable,
                      MediaItem
                    >(
                      currentTable: table,
                      referencedTable: $$ChecklistItemsTableReferences
                          ._mediaEvidenceRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChecklistItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).mediaEvidenceRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.checklistItemId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItem,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (ChecklistItem, $$ChecklistItemsTableReferences),
      ChecklistItem,
      PrefetchHooks Function({bool roomId, bool mediaEvidenceRefs})
    >;
typedef $$MediaEvidenceTableCreateCompanionBuilder =
    MediaEvidenceCompanion Function({
      required String id,
      required String roomId,
      Value<String?> checklistItemId,
      required MediaKind kind,
      required MediaSource source,
      required String originalPath,
      Value<String?> previewPath,
      Value<String?> thumbnailPath,
      Value<String> sourceFileName,
      Value<String> mimeType,
      required int byteSize,
      required String sha256,
      required DateTime recordedAt,
      Value<String?> exifDateTimeOriginal,
      Value<String?> exifMake,
      Value<String?> exifModel,
      Value<bool> originalHasGps,
      Value<int?> width,
      Value<int?> height,
      Value<String> caption,
      Value<int> rowid,
    });
typedef $$MediaEvidenceTableUpdateCompanionBuilder =
    MediaEvidenceCompanion Function({
      Value<String> id,
      Value<String> roomId,
      Value<String?> checklistItemId,
      Value<MediaKind> kind,
      Value<MediaSource> source,
      Value<String> originalPath,
      Value<String?> previewPath,
      Value<String?> thumbnailPath,
      Value<String> sourceFileName,
      Value<String> mimeType,
      Value<int> byteSize,
      Value<String> sha256,
      Value<DateTime> recordedAt,
      Value<String?> exifDateTimeOriginal,
      Value<String?> exifMake,
      Value<String?> exifModel,
      Value<bool> originalHasGps,
      Value<int?> width,
      Value<int?> height,
      Value<String> caption,
      Value<int> rowid,
    });

final class $$MediaEvidenceTableReferences
    extends BaseReferences<_$AppDatabase, $MediaEvidenceTable, MediaItem> {
  $$MediaEvidenceTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('media_evidence__room_id__rooms__id');

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<String>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChecklistItemsTable _checklistItemIdTable(_$AppDatabase db) => db
      .checklistItems
      .createAlias('media_evidence__checklist_item_id__checklist_items__id');

  $$ChecklistItemsTableProcessedTableManager? get checklistItemId {
    final $_column = $_itemColumn<String>('checklist_item_id');
    if ($_column == null) return null;
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checklistItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EvidenceHashesTable, List<EvidenceHash>>
  _evidenceHashesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evidenceHashes,
    aliasName: 'media_evidence__id__evidence_hashes__media_id',
  );

  $$EvidenceHashesTableProcessedTableManager get evidenceHashesRefs {
    final manager = $$EvidenceHashesTableTableManager(
      $_db,
      $_db.evidenceHashes,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_evidenceHashesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IssuesTable, List<Issue>> _issuesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.issues,
    aliasName: 'media_evidence__id__issues__media_id',
  );

  $$IssuesTableProcessedTableManager get issuesRefs {
    final manager = $$IssuesTableTableManager(
      $_db,
      $_db.issues,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_issuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnnotationsTable, List<Annotation>>
  _annotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotations,
    aliasName: 'media_evidence__id__annotations__media_id',
  );

  $$AnnotationsTableProcessedTableManager get annotationsRefs {
    final manager = $$AnnotationsTableTableManager(
      $_db,
      $_db.annotations,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_annotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaEvidenceTableFilterComposer
    extends Composer<_$AppDatabase, $MediaEvidenceTable> {
  $$MediaEvidenceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MediaKind, MediaKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<MediaSource, MediaSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exifDateTimeOriginal => $composableBuilder(
    column: $table.exifDateTimeOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exifMake => $composableBuilder(
    column: $table.exifMake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exifModel => $composableBuilder(
    column: $table.exifModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get originalHasGps => $composableBuilder(
    column: $table.originalHasGps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChecklistItemsTableFilterComposer get checklistItemId {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistItemId,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> evidenceHashesRefs(
    Expression<bool> Function($$EvidenceHashesTableFilterComposer f) f,
  ) {
    final $$EvidenceHashesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceHashes,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceHashesTableFilterComposer(
            $db: $db,
            $table: $db.evidenceHashes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> issuesRefs(
    Expression<bool> Function($$IssuesTableFilterComposer f) f,
  ) {
    final $$IssuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableFilterComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> annotationsRefs(
    Expression<bool> Function($$AnnotationsTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableFilterComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaEvidenceTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaEvidenceTable> {
  $$MediaEvidenceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exifDateTimeOriginal => $composableBuilder(
    column: $table.exifDateTimeOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exifMake => $composableBuilder(
    column: $table.exifMake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exifModel => $composableBuilder(
    column: $table.exifModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get originalHasGps => $composableBuilder(
    column: $table.originalHasGps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChecklistItemsTableOrderingComposer get checklistItemId {
    final $$ChecklistItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistItemId,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableOrderingComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaEvidenceTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaEvidenceTable> {
  $$MediaEvidenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previewPath => $composableBuilder(
    column: $table.previewPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFileName => $composableBuilder(
    column: $table.sourceFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exifDateTimeOriginal => $composableBuilder(
    column: $table.exifDateTimeOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exifMake =>
      $composableBuilder(column: $table.exifMake, builder: (column) => column);

  GeneratedColumn<String> get exifModel =>
      $composableBuilder(column: $table.exifModel, builder: (column) => column);

  GeneratedColumn<bool> get originalHasGps => $composableBuilder(
    column: $table.originalHasGps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChecklistItemsTableAnnotationComposer get checklistItemId {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistItemId,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> evidenceHashesRefs<T extends Object>(
    Expression<T> Function($$EvidenceHashesTableAnnotationComposer a) f,
  ) {
    final $$EvidenceHashesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidenceHashes,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceHashesTableAnnotationComposer(
            $db: $db,
            $table: $db.evidenceHashes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> issuesRefs<T extends Object>(
    Expression<T> Function($$IssuesTableAnnotationComposer a) f,
  ) {
    final $$IssuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableAnnotationComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> annotationsRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaEvidenceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaEvidenceTable,
          MediaItem,
          $$MediaEvidenceTableFilterComposer,
          $$MediaEvidenceTableOrderingComposer,
          $$MediaEvidenceTableAnnotationComposer,
          $$MediaEvidenceTableCreateCompanionBuilder,
          $$MediaEvidenceTableUpdateCompanionBuilder,
          (MediaItem, $$MediaEvidenceTableReferences),
          MediaItem,
          PrefetchHooks Function({
            bool roomId,
            bool checklistItemId,
            bool evidenceHashesRefs,
            bool issuesRefs,
            bool annotationsRefs,
          })
        > {
  $$MediaEvidenceTableTableManager(_$AppDatabase db, $MediaEvidenceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaEvidenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaEvidenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaEvidenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String?> checklistItemId = const Value.absent(),
                Value<MediaKind> kind = const Value.absent(),
                Value<MediaSource> source = const Value.absent(),
                Value<String> originalPath = const Value.absent(),
                Value<String?> previewPath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String> sourceFileName = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String?> exifDateTimeOriginal = const Value.absent(),
                Value<String?> exifMake = const Value.absent(),
                Value<String?> exifModel = const Value.absent(),
                Value<bool> originalHasGps = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String> caption = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaEvidenceCompanion(
                id: id,
                roomId: roomId,
                checklistItemId: checklistItemId,
                kind: kind,
                source: source,
                originalPath: originalPath,
                previewPath: previewPath,
                thumbnailPath: thumbnailPath,
                sourceFileName: sourceFileName,
                mimeType: mimeType,
                byteSize: byteSize,
                sha256: sha256,
                recordedAt: recordedAt,
                exifDateTimeOriginal: exifDateTimeOriginal,
                exifMake: exifMake,
                exifModel: exifModel,
                originalHasGps: originalHasGps,
                width: width,
                height: height,
                caption: caption,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                Value<String?> checklistItemId = const Value.absent(),
                required MediaKind kind,
                required MediaSource source,
                required String originalPath,
                Value<String?> previewPath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String> sourceFileName = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                required int byteSize,
                required String sha256,
                required DateTime recordedAt,
                Value<String?> exifDateTimeOriginal = const Value.absent(),
                Value<String?> exifMake = const Value.absent(),
                Value<String?> exifModel = const Value.absent(),
                Value<bool> originalHasGps = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String> caption = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaEvidenceCompanion.insert(
                id: id,
                roomId: roomId,
                checklistItemId: checklistItemId,
                kind: kind,
                source: source,
                originalPath: originalPath,
                previewPath: previewPath,
                thumbnailPath: thumbnailPath,
                sourceFileName: sourceFileName,
                mimeType: mimeType,
                byteSize: byteSize,
                sha256: sha256,
                recordedAt: recordedAt,
                exifDateTimeOriginal: exifDateTimeOriginal,
                exifMake: exifMake,
                exifModel: exifModel,
                originalHasGps: originalHasGps,
                width: width,
                height: height,
                caption: caption,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaEvidenceTable, MediaItem>(table),
                  $$MediaEvidenceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                roomId = false,
                checklistItemId = false,
                evidenceHashesRefs = false,
                issuesRefs = false,
                annotationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (evidenceHashesRefs) db.evidenceHashes,
                    if (issuesRefs) db.issues,
                    if (annotationsRefs) db.annotations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roomId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roomId,
                            referencedTable: $$MediaEvidenceTableReferences
                                ._roomIdTable(db),
                            referencedColumn: $$MediaEvidenceTableReferences
                                ._roomIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (checklistItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.checklistItemId,
                            referencedTable: $$MediaEvidenceTableReferences
                                ._checklistItemIdTable(db),
                            referencedColumn: $$MediaEvidenceTableReferences
                                ._checklistItemIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (evidenceHashesRefs)
                        await $_getPrefetchedData<
                          MediaItem,
                          $MediaEvidenceTable,
                          EvidenceHash
                        >(
                          currentTable: table,
                          referencedTable: $$MediaEvidenceTableReferences
                              ._evidenceHashesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaEvidenceTableReferences(
                                db,
                                table,
                                p0,
                              ).evidenceHashesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (issuesRefs)
                        await $_getPrefetchedData<
                          MediaItem,
                          $MediaEvidenceTable,
                          Issue
                        >(
                          currentTable: table,
                          referencedTable: $$MediaEvidenceTableReferences
                              ._issuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaEvidenceTableReferences(
                                db,
                                table,
                                p0,
                              ).issuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (annotationsRefs)
                        await $_getPrefetchedData<
                          MediaItem,
                          $MediaEvidenceTable,
                          Annotation
                        >(
                          currentTable: table,
                          referencedTable: $$MediaEvidenceTableReferences
                              ._annotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaEvidenceTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediaEvidenceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaEvidenceTable,
      MediaItem,
      $$MediaEvidenceTableFilterComposer,
      $$MediaEvidenceTableOrderingComposer,
      $$MediaEvidenceTableAnnotationComposer,
      $$MediaEvidenceTableCreateCompanionBuilder,
      $$MediaEvidenceTableUpdateCompanionBuilder,
      (MediaItem, $$MediaEvidenceTableReferences),
      MediaItem,
      PrefetchHooks Function({
        bool roomId,
        bool checklistItemId,
        bool evidenceHashesRefs,
        bool issuesRefs,
        bool annotationsRefs,
      })
    >;
typedef $$EvidenceHashesTableCreateCompanionBuilder =
    EvidenceHashesCompanion Function({
      required String id,
      required String mediaId,
      Value<String> algorithm,
      Value<String?> hexDigest,
      required HashPurpose purpose,
      required HashCheckResult result,
      required DateTime computedAt,
      Value<int> rowid,
    });
typedef $$EvidenceHashesTableUpdateCompanionBuilder =
    EvidenceHashesCompanion Function({
      Value<String> id,
      Value<String> mediaId,
      Value<String> algorithm,
      Value<String?> hexDigest,
      Value<HashPurpose> purpose,
      Value<HashCheckResult> result,
      Value<DateTime> computedAt,
      Value<int> rowid,
    });

final class $$EvidenceHashesTableReferences
    extends BaseReferences<_$AppDatabase, $EvidenceHashesTable, EvidenceHash> {
  $$EvidenceHashesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MediaEvidenceTable _mediaIdTable(_$AppDatabase db) => db.mediaEvidence
      .createAlias('evidence_hashes__media_id__media_evidence__id');

  $$MediaEvidenceTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<String>('media_id')!;

    final manager = $$MediaEvidenceTableTableManager(
      $_db,
      $_db.mediaEvidence,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EvidenceHashesTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceHashesTable> {
  $$EvidenceHashesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hexDigest => $composableBuilder(
    column: $table.hexDigest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HashPurpose, HashPurpose, String>
  get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<HashCheckResult, HashCheckResult, String>
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaEvidenceTableFilterComposer get mediaId {
    final $$MediaEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceHashesTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceHashesTable> {
  $$EvidenceHashesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hexDigest => $composableBuilder(
    column: $table.hexDigest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaEvidenceTableOrderingComposer get mediaId {
    final $$MediaEvidenceTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableOrderingComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceHashesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceHashesTable> {
  $$EvidenceHashesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get algorithm =>
      $composableBuilder(column: $table.algorithm, builder: (column) => column);

  GeneratedColumn<String> get hexDigest =>
      $composableBuilder(column: $table.hexDigest, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HashPurpose, String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HashCheckResult, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => column,
  );

  $$MediaEvidenceTableAnnotationComposer get mediaId {
    final $$MediaEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceHashesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvidenceHashesTable,
          EvidenceHash,
          $$EvidenceHashesTableFilterComposer,
          $$EvidenceHashesTableOrderingComposer,
          $$EvidenceHashesTableAnnotationComposer,
          $$EvidenceHashesTableCreateCompanionBuilder,
          $$EvidenceHashesTableUpdateCompanionBuilder,
          (EvidenceHash, $$EvidenceHashesTableReferences),
          EvidenceHash,
          PrefetchHooks Function({bool mediaId})
        > {
  $$EvidenceHashesTableTableManager(
    _$AppDatabase db,
    $EvidenceHashesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceHashesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceHashesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceHashesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mediaId = const Value.absent(),
                Value<String> algorithm = const Value.absent(),
                Value<String?> hexDigest = const Value.absent(),
                Value<HashPurpose> purpose = const Value.absent(),
                Value<HashCheckResult> result = const Value.absent(),
                Value<DateTime> computedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceHashesCompanion(
                id: id,
                mediaId: mediaId,
                algorithm: algorithm,
                hexDigest: hexDigest,
                purpose: purpose,
                result: result,
                computedAt: computedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mediaId,
                Value<String> algorithm = const Value.absent(),
                Value<String?> hexDigest = const Value.absent(),
                required HashPurpose purpose,
                required HashCheckResult result,
                required DateTime computedAt,
                Value<int> rowid = const Value.absent(),
              }) => EvidenceHashesCompanion.insert(
                id: id,
                mediaId: mediaId,
                algorithm: algorithm,
                hexDigest: hexDigest,
                purpose: purpose,
                result: result,
                computedAt: computedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EvidenceHashesTable, EvidenceHash>(table),
                  $$EvidenceHashesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$EvidenceHashesTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$EvidenceHashesTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EvidenceHashesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvidenceHashesTable,
      EvidenceHash,
      $$EvidenceHashesTableFilterComposer,
      $$EvidenceHashesTableOrderingComposer,
      $$EvidenceHashesTableAnnotationComposer,
      $$EvidenceHashesTableCreateCompanionBuilder,
      $$EvidenceHashesTableUpdateCompanionBuilder,
      (EvidenceHash, $$EvidenceHashesTableReferences),
      EvidenceHash,
      PrefetchHooks Function({bool mediaId})
    >;
typedef $$IssuesTableCreateCompanionBuilder = IssuesCompanion Function({
  required String id,
  required String roomId,
  Value<String?> mediaId,
  required String title,
  Value<String> description,
  required IssueCategory category,
  required IssueSeverity severity,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$IssuesTableUpdateCompanionBuilder = IssuesCompanion Function({
  Value<String> id,
  Value<String> roomId,
  Value<String?> mediaId,
  Value<String> title,
  Value<String> description,
  Value<IssueCategory> category,
  Value<IssueSeverity> severity,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$IssuesTableReferences
    extends BaseReferences<_$AppDatabase, $IssuesTable, Issue> {
  $$IssuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('issues__room_id__rooms__id');

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<String>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediaEvidenceTable _mediaIdTable(_$AppDatabase db) =>
      db.mediaEvidence.createAlias('issues__media_id__media_evidence__id');

  $$MediaEvidenceTableProcessedTableManager? get mediaId {
    final $_column = $_itemColumn<String>('media_id');
    if ($_column == null) return null;
    final manager = $$MediaEvidenceTableTableManager(
      $_db,
      $_db.mediaEvidence,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AnnotationsTable, List<Annotation>>
  _annotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotations,
    aliasName: 'issues__id__annotations__issue_id',
  );

  $$AnnotationsTableProcessedTableManager get annotationsRefs {
    final manager = $$AnnotationsTableTableManager(
      $_db,
      $_db.annotations,
    ).filter((f) => f.issueId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_annotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IssuesTableFilterComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IssueCategory, IssueCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<IssueSeverity, IssueSeverity, String>
  get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaEvidenceTableFilterComposer get mediaId {
    final $$MediaEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> annotationsRefs(
    Expression<bool> Function($$AnnotationsTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.issueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableFilterComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IssuesTableOrderingComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaEvidenceTableOrderingComposer get mediaId {
    final $$MediaEvidenceTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableOrderingComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IssuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IssuesTable> {
  $$IssuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IssueCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IssueSeverity, String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaEvidenceTableAnnotationComposer get mediaId {
    final $$MediaEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> annotationsRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.issueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IssuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IssuesTable,
          Issue,
          $$IssuesTableFilterComposer,
          $$IssuesTableOrderingComposer,
          $$IssuesTableAnnotationComposer,
          $$IssuesTableCreateCompanionBuilder,
          $$IssuesTableUpdateCompanionBuilder,
          (Issue, $$IssuesTableReferences),
          Issue,
          PrefetchHooks Function({
            bool roomId,
            bool mediaId,
            bool annotationsRefs,
          })
        > {
  $$IssuesTableTableManager(_$AppDatabase db, $IssuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IssuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IssuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IssuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String?> mediaId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<IssueCategory> category = const Value.absent(),
                Value<IssueSeverity> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IssuesCompanion(
                id: id,
                roomId: roomId,
                mediaId: mediaId,
                title: title,
                description: description,
                category: category,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                Value<String?> mediaId = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                required IssueCategory category,
                required IssueSeverity severity,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => IssuesCompanion.insert(
                id: id,
                roomId: roomId,
                mediaId: mediaId,
                title: title,
                description: description,
                category: category,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IssuesTable, Issue>(table),
                  $$IssuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({roomId = false, mediaId = false, annotationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (annotationsRefs) db.annotations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roomId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roomId,
                            referencedTable: $$IssuesTableReferences
                                ._roomIdTable(db),
                            referencedColumn: $$IssuesTableReferences
                                ._roomIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (mediaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.mediaId,
                            referencedTable: $$IssuesTableReferences
                                ._mediaIdTable(db),
                            referencedColumn: $$IssuesTableReferences
                                ._mediaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (annotationsRefs)
                        await $_getPrefetchedData<
                          Issue,
                          $IssuesTable,
                          Annotation
                        >(
                          currentTable: table,
                          referencedTable: $$IssuesTableReferences
                              ._annotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IssuesTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.issueId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IssuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IssuesTable,
      Issue,
      $$IssuesTableFilterComposer,
      $$IssuesTableOrderingComposer,
      $$IssuesTableAnnotationComposer,
      $$IssuesTableCreateCompanionBuilder,
      $$IssuesTableUpdateCompanionBuilder,
      (Issue, $$IssuesTableReferences),
      Issue,
      PrefetchHooks Function({bool roomId, bool mediaId, bool annotationsRefs})
    >;
typedef $$AnnotationsTableCreateCompanionBuilder =
    AnnotationsCompanion Function({
      required String id,
      required String mediaId,
      Value<String?> issueId,
      required double x,
      required double y,
      Value<String> label,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AnnotationsTableUpdateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<String> id,
      Value<String> mediaId,
      Value<String?> issueId,
      Value<double> x,
      Value<double> y,
      Value<String> label,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AnnotationsTableReferences
    extends BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation> {
  $$AnnotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaEvidenceTable _mediaIdTable(_$AppDatabase db) =>
      db.mediaEvidence.createAlias('annotations__media_id__media_evidence__id');

  $$MediaEvidenceTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<String>('media_id')!;

    final manager = $$MediaEvidenceTableTableManager(
      $_db,
      $_db.mediaEvidence,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IssuesTable _issueIdTable(_$AppDatabase db) =>
      db.issues.createAlias('annotations__issue_id__issues__id');

  $$IssuesTableProcessedTableManager? get issueId {
    final $_column = $_itemColumn<String>('issue_id');
    if ($_column == null) return null;
    final manager = $$IssuesTableTableManager(
      $_db,
      $_db.issues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_issueIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnotationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaEvidenceTableFilterComposer get mediaId {
    final $$MediaEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IssuesTableFilterComposer get issueId {
    final $$IssuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.issueId,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableFilterComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaEvidenceTableOrderingComposer get mediaId {
    final $$MediaEvidenceTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableOrderingComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IssuesTableOrderingComposer get issueId {
    final $$IssuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.issueId,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableOrderingComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MediaEvidenceTableAnnotationComposer get mediaId {
    final $$MediaEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaEvidence,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IssuesTableAnnotationComposer get issueId {
    final $$IssuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.issueId,
      referencedTable: $db.issues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IssuesTableAnnotationComposer(
            $db: $db,
            $table: $db.issues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTable,
          Annotation,
          $$AnnotationsTableFilterComposer,
          $$AnnotationsTableOrderingComposer,
          $$AnnotationsTableAnnotationComposer,
          $$AnnotationsTableCreateCompanionBuilder,
          $$AnnotationsTableUpdateCompanionBuilder,
          (Annotation, $$AnnotationsTableReferences),
          Annotation,
          PrefetchHooks Function({bool mediaId, bool issueId})
        > {
  $$AnnotationsTableTableManager(_$AppDatabase db, $AnnotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mediaId = const Value.absent(),
                Value<String?> issueId = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion(
                id: id,
                mediaId: mediaId,
                issueId: issueId,
                x: x,
                y: y,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mediaId,
                Value<String?> issueId = const Value.absent(),
                required double x,
                required double y,
                Value<String> label = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion.insert(
                id: id,
                mediaId: mediaId,
                issueId: issueId,
                x: x,
                y: y,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnnotationsTable, Annotation>(table),
                  $$AnnotationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false, issueId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$AnnotationsTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$AnnotationsTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (issueId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.issueId,
                        referencedTable: $$AnnotationsTableReferences
                            ._issueIdTable(db),
                        referencedColumn: $$AnnotationsTableReferences
                            ._issueIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTable,
      Annotation,
      $$AnnotationsTableFilterComposer,
      $$AnnotationsTableOrderingComposer,
      $$AnnotationsTableAnnotationComposer,
      $$AnnotationsTableCreateCompanionBuilder,
      $$AnnotationsTableUpdateCompanionBuilder,
      (Annotation, $$AnnotationsTableReferences),
      Annotation,
      PrefetchHooks Function({bool mediaId, bool issueId})
    >;
typedef $$ReportsTableCreateCompanionBuilder = ReportsCompanion Function({
  required String id,
  required String inspectionId,
  required String filePath,
  required String sha256,
  required int byteSize,
  required int mediaCount,
  required int issueCount,
  Value<bool> includesComparison,
  required DateTime generatedAt,
  Value<DateTime?> sentToLandlordAt,
  Value<int> rowid,
});
typedef $$ReportsTableUpdateCompanionBuilder = ReportsCompanion Function({
  Value<String> id,
  Value<String> inspectionId,
  Value<String> filePath,
  Value<String> sha256,
  Value<int> byteSize,
  Value<int> mediaCount,
  Value<int> issueCount,
  Value<bool> includesComparison,
  Value<DateTime> generatedAt,
  Value<DateTime?> sentToLandlordAt,
  Value<int> rowid,
});

final class $$ReportsTableReferences
    extends BaseReferences<_$AppDatabase, $ReportsTable, Report> {
  $$ReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias('reports__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<String>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get issueCount => $composableBuilder(
    column: $table.issueCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includesComparison => $composableBuilder(
    column: $table.includesComparison,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentToLandlordAt => $composableBuilder(
    column: $table.sentToLandlordAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get issueCount => $composableBuilder(
    column: $table.issueCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includesComparison => $composableBuilder(
    column: $table.includesComparison,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentToLandlordAt => $composableBuilder(
    column: $table.sentToLandlordAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get issueCount => $composableBuilder(
    column: $table.issueCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get includesComparison => $composableBuilder(
    column: $table.includesComparison,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentToLandlordAt => $composableBuilder(
    column: $table.sentToLandlordAt,
    builder: (column) => column,
  );

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsTable,
          Report,
          $$ReportsTableFilterComposer,
          $$ReportsTableOrderingComposer,
          $$ReportsTableAnnotationComposer,
          $$ReportsTableCreateCompanionBuilder,
          $$ReportsTableUpdateCompanionBuilder,
          (Report, $$ReportsTableReferences),
          Report,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$ReportsTableTableManager(_$AppDatabase db, $ReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<int> mediaCount = const Value.absent(),
                Value<int> issueCount = const Value.absent(),
                Value<bool> includesComparison = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<DateTime?> sentToLandlordAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion(
                id: id,
                inspectionId: inspectionId,
                filePath: filePath,
                sha256: sha256,
                byteSize: byteSize,
                mediaCount: mediaCount,
                issueCount: issueCount,
                includesComparison: includesComparison,
                generatedAt: generatedAt,
                sentToLandlordAt: sentToLandlordAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inspectionId,
                required String filePath,
                required String sha256,
                required int byteSize,
                required int mediaCount,
                required int issueCount,
                Value<bool> includesComparison = const Value.absent(),
                required DateTime generatedAt,
                Value<DateTime?> sentToLandlordAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                filePath: filePath,
                sha256: sha256,
                byteSize: byteSize,
                mediaCount: mediaCount,
                issueCount: issueCount,
                includesComparison: includesComparison,
                generatedAt: generatedAt,
                sentToLandlordAt: sentToLandlordAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportsTable, Report>(table),
                  $$ReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.inspectionId,
                        referencedTable: $$ReportsTableReferences
                            ._inspectionIdTable(db),
                        referencedColumn: $$ReportsTableReferences
                            ._inspectionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsTable,
      Report,
      $$ReportsTableFilterComposer,
      $$ReportsTableOrderingComposer,
      $$ReportsTableAnnotationComposer,
      $$ReportsTableCreateCompanionBuilder,
      $$ReportsTableUpdateCompanionBuilder,
      (Report, $$ReportsTableReferences),
      Report,
      PrefetchHooks Function({bool inspectionId})
    >;
typedef $$RoomComparisonsTableCreateCompanionBuilder =
    RoomComparisonsCompanion Function({
      required String id,
      required String roomId,
      required ComparisonVerdict verdict,
      Value<String> note,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoomComparisonsTableUpdateCompanionBuilder =
    RoomComparisonsCompanion Function({
      Value<String> id,
      Value<String> roomId,
      Value<ComparisonVerdict> verdict,
      Value<String> note,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoomComparisonsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoomComparisonsTable, RoomComparison> {
  $$RoomComparisonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('room_comparisons__room_id__rooms__id');

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<String>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoomComparisonsTableFilterComposer
    extends Composer<_$AppDatabase, $RoomComparisonsTable> {
  $$RoomComparisonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ComparisonVerdict, ComparisonVerdict, String>
  get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomComparisonsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomComparisonsTable> {
  $$RoomComparisonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomComparisonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomComparisonsTable> {
  $$RoomComparisonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ComparisonVerdict, String> get verdict =>
      $composableBuilder(column: $table.verdict, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomComparisonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomComparisonsTable,
          RoomComparison,
          $$RoomComparisonsTableFilterComposer,
          $$RoomComparisonsTableOrderingComposer,
          $$RoomComparisonsTableAnnotationComposer,
          $$RoomComparisonsTableCreateCompanionBuilder,
          $$RoomComparisonsTableUpdateCompanionBuilder,
          (RoomComparison, $$RoomComparisonsTableReferences),
          RoomComparison,
          PrefetchHooks Function({bool roomId})
        > {
  $$RoomComparisonsTableTableManager(
    _$AppDatabase db,
    $RoomComparisonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomComparisonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomComparisonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomComparisonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<ComparisonVerdict> verdict = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomComparisonsCompanion(
                id: id,
                roomId: roomId,
                verdict: verdict,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                required ComparisonVerdict verdict,
                Value<String> note = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoomComparisonsCompanion.insert(
                id: id,
                roomId: roomId,
                verdict: verdict,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomComparisonsTable, RoomComparison>(table),
                  $$RoomComparisonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (roomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.roomId,
                        referencedTable: $$RoomComparisonsTableReferences
                            ._roomIdTable(db),
                        referencedColumn: $$RoomComparisonsTableReferences
                            ._roomIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoomComparisonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomComparisonsTable,
      RoomComparison,
      $$RoomComparisonsTableFilterComposer,
      $$RoomComparisonsTableOrderingComposer,
      $$RoomComparisonsTableAnnotationComposer,
      $$RoomComparisonsTableCreateCompanionBuilder,
      $$RoomComparisonsTableUpdateCompanionBuilder,
      (RoomComparison, $$RoomComparisonsTableReferences),
      RoomComparison,
      PrefetchHooks Function({bool roomId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$MediaEvidenceTableTableManager get mediaEvidence =>
      $$MediaEvidenceTableTableManager(_db, _db.mediaEvidence);
  $$EvidenceHashesTableTableManager get evidenceHashes =>
      $$EvidenceHashesTableTableManager(_db, _db.evidenceHashes);
  $$IssuesTableTableManager get issues =>
      $$IssuesTableTableManager(_db, _db.issues);
  $$AnnotationsTableTableManager get annotations =>
      $$AnnotationsTableTableManager(_db, _db.annotations);
  $$ReportsTableTableManager get reports =>
      $$ReportsTableTableManager(_db, _db.reports);
  $$RoomComparisonsTableTableManager get roomComparisons =>
      $$RoomComparisonsTableTableManager(_db, _db.roomComparisons);
}
