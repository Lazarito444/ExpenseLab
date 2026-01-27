// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    currencyCode,
    currentBalance,
    colorHex,
    iconCodePoint,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountDbModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentBalanceMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountDbModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_balance'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountDbModel extends DataClass implements Insertable<AccountDbModel> {
  final int id;
  final String name;
  final String currencyCode;
  final double currentBalance;
  final String colorHex;
  final int iconCodePoint;
  final bool isArchived;
  const AccountDbModel({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.currentBalance,
    required this.colorHex,
    required this.iconCodePoint,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['currency_code'] = Variable<String>(currencyCode);
    map['current_balance'] = Variable<double>(currentBalance);
    map['color_hex'] = Variable<String>(colorHex);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      currentBalance: Value(currentBalance),
      colorHex: Value(colorHex),
      iconCodePoint: Value(iconCodePoint),
      isArchived: Value(isArchived),
    );
  }

  factory AccountDbModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountDbModel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'colorHex': serializer.toJson<String>(colorHex),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  AccountDbModel copyWith({
    int? id,
    String? name,
    String? currencyCode,
    double? currentBalance,
    String? colorHex,
    int? iconCodePoint,
    bool? isArchived,
  }) => AccountDbModel(
    id: id ?? this.id,
    name: name ?? this.name,
    currencyCode: currencyCode ?? this.currencyCode,
    currentBalance: currentBalance ?? this.currentBalance,
    colorHex: colorHex ?? this.colorHex,
    iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    isArchived: isArchived ?? this.isArchived,
  );
  AccountDbModel copyWithCompanion(AccountsCompanion data) {
    return AccountDbModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountDbModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    currencyCode,
    currentBalance,
    colorHex,
    iconCodePoint,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountDbModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.currencyCode == this.currencyCode &&
          other.currentBalance == this.currentBalance &&
          other.colorHex == this.colorHex &&
          other.iconCodePoint == this.iconCodePoint &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<AccountDbModel> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> currencyCode;
  final Value<double> currentBalance;
  final Value<String> colorHex;
  final Value<int> iconCodePoint;
  final Value<bool> isArchived;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String currencyCode,
    required double currentBalance,
    required String colorHex,
    required int iconCodePoint,
    this.isArchived = const Value.absent(),
  }) : name = Value(name),
       currencyCode = Value(currencyCode),
       currentBalance = Value(currentBalance),
       colorHex = Value(colorHex),
       iconCodePoint = Value(iconCodePoint);
  static Insertable<AccountDbModel> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? currencyCode,
    Expression<double>? currentBalance,
    Expression<String>? colorHex,
    Expression<int>? iconCodePoint,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (colorHex != null) 'color_hex': colorHex,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? currencyCode,
    Value<double>? currentBalance,
    Value<String>? colorHex,
    Value<int>? iconCodePoint,
    Value<bool>? isArchived,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      currentBalance: currentBalance ?? this.currentBalance,
      colorHex: colorHex ?? this.colorHex,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $FinancialEventsTable extends FinancialEvents
    with TableInfo<$FinancialEventsTable, FinancialEventDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _aggregateIdMeta = const VerificationMeta(
    'aggregateId',
  );
  @override
  late final GeneratedColumn<String> aggregateId = GeneratedColumn<String>(
    'aggregate_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    aggregateId,
    eventType,
    timestamp,
    payloadJson,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialEventDbModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('aggregate_id')) {
      context.handle(
        _aggregateIdMeta,
        aggregateId.isAcceptableOrUnknown(
          data['aggregate_id']!,
          _aggregateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_aggregateIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {aggregateId, version},
  ];
  @override
  FinancialEventDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialEventDbModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      aggregateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aggregate_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $FinancialEventsTable createAlias(String alias) {
    return $FinancialEventsTable(attachedDatabase, alias);
  }
}

class FinancialEventDbModel extends DataClass
    implements Insertable<FinancialEventDbModel> {
  final int id;
  final String aggregateId;
  final String eventType;
  final DateTime timestamp;
  final String payloadJson;
  final int version;
  const FinancialEventDbModel({
    required this.id,
    required this.aggregateId,
    required this.eventType,
    required this.timestamp,
    required this.payloadJson,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['aggregate_id'] = Variable<String>(aggregateId);
    map['event_type'] = Variable<String>(eventType);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['payload_json'] = Variable<String>(payloadJson);
    map['version'] = Variable<int>(version);
    return map;
  }

  FinancialEventsCompanion toCompanion(bool nullToAbsent) {
    return FinancialEventsCompanion(
      id: Value(id),
      aggregateId: Value(aggregateId),
      eventType: Value(eventType),
      timestamp: Value(timestamp),
      payloadJson: Value(payloadJson),
      version: Value(version),
    );
  }

  factory FinancialEventDbModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialEventDbModel(
      id: serializer.fromJson<int>(json['id']),
      aggregateId: serializer.fromJson<String>(json['aggregateId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'aggregateId': serializer.toJson<String>(aggregateId),
      'eventType': serializer.toJson<String>(eventType),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'version': serializer.toJson<int>(version),
    };
  }

  FinancialEventDbModel copyWith({
    int? id,
    String? aggregateId,
    String? eventType,
    DateTime? timestamp,
    String? payloadJson,
    int? version,
  }) => FinancialEventDbModel(
    id: id ?? this.id,
    aggregateId: aggregateId ?? this.aggregateId,
    eventType: eventType ?? this.eventType,
    timestamp: timestamp ?? this.timestamp,
    payloadJson: payloadJson ?? this.payloadJson,
    version: version ?? this.version,
  );
  FinancialEventDbModel copyWithCompanion(FinancialEventsCompanion data) {
    return FinancialEventDbModel(
      id: data.id.present ? data.id.value : this.id,
      aggregateId: data.aggregateId.present
          ? data.aggregateId.value
          : this.aggregateId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialEventDbModel(')
          ..write('id: $id, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, aggregateId, eventType, timestamp, payloadJson, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialEventDbModel &&
          other.id == this.id &&
          other.aggregateId == this.aggregateId &&
          other.eventType == this.eventType &&
          other.timestamp == this.timestamp &&
          other.payloadJson == this.payloadJson &&
          other.version == this.version);
}

class FinancialEventsCompanion extends UpdateCompanion<FinancialEventDbModel> {
  final Value<int> id;
  final Value<String> aggregateId;
  final Value<String> eventType;
  final Value<DateTime> timestamp;
  final Value<String> payloadJson;
  final Value<int> version;
  const FinancialEventsCompanion({
    this.id = const Value.absent(),
    this.aggregateId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.version = const Value.absent(),
  });
  FinancialEventsCompanion.insert({
    this.id = const Value.absent(),
    required String aggregateId,
    required String eventType,
    required DateTime timestamp,
    required String payloadJson,
    required int version,
  }) : aggregateId = Value(aggregateId),
       eventType = Value(eventType),
       timestamp = Value(timestamp),
       payloadJson = Value(payloadJson),
       version = Value(version);
  static Insertable<FinancialEventDbModel> custom({
    Expression<int>? id,
    Expression<String>? aggregateId,
    Expression<String>? eventType,
    Expression<DateTime>? timestamp,
    Expression<String>? payloadJson,
    Expression<int>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (aggregateId != null) 'aggregate_id': aggregateId,
      if (eventType != null) 'event_type': eventType,
      if (timestamp != null) 'timestamp': timestamp,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (version != null) 'version': version,
    });
  }

  FinancialEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? aggregateId,
    Value<String>? eventType,
    Value<DateTime>? timestamp,
    Value<String>? payloadJson,
    Value<int>? version,
  }) {
    return FinancialEventsCompanion(
      id: id ?? this.id,
      aggregateId: aggregateId ?? this.aggregateId,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      payloadJson: payloadJson ?? this.payloadJson,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (aggregateId.present) {
      map['aggregate_id'] = Variable<String>(aggregateId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialEventsCompanion(')
          ..write('id: $id, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $FinancialEventsTable financialEvents = $FinancialEventsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    financialEvents,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String name,
      required String currencyCode,
      required double currentBalance,
      required String colorHex,
      required int iconCodePoint,
      Value<bool> isArchived,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> currencyCode,
      Value<double> currentBalance,
      Value<String> colorHex,
      Value<int> iconCodePoint,
      Value<bool> isArchived,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountDbModel,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountDbModel,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountDbModel>,
          ),
          AccountDbModel,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> currentBalance = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> iconCodePoint = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                currencyCode: currencyCode,
                currentBalance: currentBalance,
                colorHex: colorHex,
                iconCodePoint: iconCodePoint,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String currencyCode,
                required double currentBalance,
                required String colorHex,
                required int iconCodePoint,
                Value<bool> isArchived = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                currencyCode: currencyCode,
                currentBalance: currentBalance,
                colorHex: colorHex,
                iconCodePoint: iconCodePoint,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountDbModel,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (
        AccountDbModel,
        BaseReferences<_$AppDatabase, $AccountsTable, AccountDbModel>,
      ),
      AccountDbModel,
      PrefetchHooks Function()
    >;
typedef $$FinancialEventsTableCreateCompanionBuilder =
    FinancialEventsCompanion Function({
      Value<int> id,
      required String aggregateId,
      required String eventType,
      required DateTime timestamp,
      required String payloadJson,
      required int version,
    });
typedef $$FinancialEventsTableUpdateCompanionBuilder =
    FinancialEventsCompanion Function({
      Value<int> id,
      Value<String> aggregateId,
      Value<String> eventType,
      Value<DateTime> timestamp,
      Value<String> payloadJson,
      Value<int> version,
    });

class $$FinancialEventsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialEventsTable> {
  $$FinancialEventsTableFilterComposer({
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

  ColumnFilters<String> get aggregateId => $composableBuilder(
    column: $table.aggregateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialEventsTable> {
  $$FinancialEventsTableOrderingComposer({
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

  ColumnOrderings<String> get aggregateId => $composableBuilder(
    column: $table.aggregateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialEventsTable> {
  $$FinancialEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get aggregateId => $composableBuilder(
    column: $table.aggregateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$FinancialEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialEventsTable,
          FinancialEventDbModel,
          $$FinancialEventsTableFilterComposer,
          $$FinancialEventsTableOrderingComposer,
          $$FinancialEventsTableAnnotationComposer,
          $$FinancialEventsTableCreateCompanionBuilder,
          $$FinancialEventsTableUpdateCompanionBuilder,
          (
            FinancialEventDbModel,
            BaseReferences<
              _$AppDatabase,
              $FinancialEventsTable,
              FinancialEventDbModel
            >,
          ),
          FinancialEventDbModel,
          PrefetchHooks Function()
        > {
  $$FinancialEventsTableTableManager(
    _$AppDatabase db,
    $FinancialEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> aggregateId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => FinancialEventsCompanion(
                id: id,
                aggregateId: aggregateId,
                eventType: eventType,
                timestamp: timestamp,
                payloadJson: payloadJson,
                version: version,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String aggregateId,
                required String eventType,
                required DateTime timestamp,
                required String payloadJson,
                required int version,
              }) => FinancialEventsCompanion.insert(
                id: id,
                aggregateId: aggregateId,
                eventType: eventType,
                timestamp: timestamp,
                payloadJson: payloadJson,
                version: version,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialEventsTable,
      FinancialEventDbModel,
      $$FinancialEventsTableFilterComposer,
      $$FinancialEventsTableOrderingComposer,
      $$FinancialEventsTableAnnotationComposer,
      $$FinancialEventsTableCreateCompanionBuilder,
      $$FinancialEventsTableUpdateCompanionBuilder,
      (
        FinancialEventDbModel,
        BaseReferences<
          _$AppDatabase,
          $FinancialEventsTable,
          FinancialEventDbModel
        >,
      ),
      FinancialEventDbModel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$FinancialEventsTableTableManager get financialEvents =>
      $$FinancialEventsTableTableManager(_db, _db.financialEvents);
}
