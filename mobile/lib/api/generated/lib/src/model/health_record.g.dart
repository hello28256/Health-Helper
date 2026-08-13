// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthRecord extends HealthRecord {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final HealthMetric? metric;
  @override
  final num? value;
  @override
  final String? unit;
  @override
  final DateTime? startAt;
  @override
  final DateTime? endAt;
  @override
  final String? source_;
  @override
  final BuiltMap<String, JsonObject?>? raw;
  @override
  final DateTime? createdAt;

  factory _$HealthRecord([void Function(HealthRecordBuilder)? updates]) =>
      (HealthRecordBuilder()..update(updates))._build();

  _$HealthRecord._(
      {this.id,
      this.userId,
      this.metric,
      this.value,
      this.unit,
      this.startAt,
      this.endAt,
      this.source_,
      this.raw,
      this.createdAt})
      : super._();
  @override
  HealthRecord rebuild(void Function(HealthRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthRecordBuilder toBuilder() => HealthRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthRecord &&
        id == other.id &&
        userId == other.userId &&
        metric == other.metric &&
        value == other.value &&
        unit == other.unit &&
        startAt == other.startAt &&
        endAt == other.endAt &&
        source_ == other.source_ &&
        raw == other.raw &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, metric.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, startAt.hashCode);
    _$hash = $jc(_$hash, endAt.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, raw.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthRecord')
          ..add('id', id)
          ..add('userId', userId)
          ..add('metric', metric)
          ..add('value', value)
          ..add('unit', unit)
          ..add('startAt', startAt)
          ..add('endAt', endAt)
          ..add('source_', source_)
          ..add('raw', raw)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class HealthRecordBuilder
    implements Builder<HealthRecord, HealthRecordBuilder> {
  _$HealthRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  HealthMetric? _metric;
  HealthMetric? get metric => _$this._metric;
  set metric(HealthMetric? metric) => _$this._metric = metric;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  DateTime? _startAt;
  DateTime? get startAt => _$this._startAt;
  set startAt(DateTime? startAt) => _$this._startAt = startAt;

  DateTime? _endAt;
  DateTime? get endAt => _$this._endAt;
  set endAt(DateTime? endAt) => _$this._endAt = endAt;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  MapBuilder<String, JsonObject?>? _raw;
  MapBuilder<String, JsonObject?> get raw =>
      _$this._raw ??= MapBuilder<String, JsonObject?>();
  set raw(MapBuilder<String, JsonObject?>? raw) => _$this._raw = raw;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  HealthRecordBuilder() {
    HealthRecord._defaults(this);
  }

  HealthRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _metric = $v.metric;
      _value = $v.value;
      _unit = $v.unit;
      _startAt = $v.startAt;
      _endAt = $v.endAt;
      _source_ = $v.source_;
      _raw = $v.raw?.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthRecord other) {
    _$v = other as _$HealthRecord;
  }

  @override
  void update(void Function(HealthRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthRecord build() => _build();

  _$HealthRecord _build() {
    _$HealthRecord _$result;
    try {
      _$result = _$v ??
          _$HealthRecord._(
            id: id,
            userId: userId,
            metric: metric,
            value: value,
            unit: unit,
            startAt: startAt,
            endAt: endAt,
            source_: source_,
            raw: _raw?.build(),
            createdAt: createdAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'raw';
        _raw?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HealthRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
