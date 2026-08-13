// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_health_records_post_request_records_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiHealthRecordsPostRequestRecordsInner
    extends ApiHealthRecordsPostRequestRecordsInner {
  @override
  final HealthMetric metric;
  @override
  final num value;
  @override
  final String unit;
  @override
  final DateTime startAt;
  @override
  final DateTime? endAt;
  @override
  final String source_;
  @override
  final BuiltMap<String, JsonObject?>? raw;

  factory _$ApiHealthRecordsPostRequestRecordsInner(
          [void Function(ApiHealthRecordsPostRequestRecordsInnerBuilder)?
              updates]) =>
      (ApiHealthRecordsPostRequestRecordsInnerBuilder()..update(updates))
          ._build();

  _$ApiHealthRecordsPostRequestRecordsInner._(
      {required this.metric,
      required this.value,
      required this.unit,
      required this.startAt,
      this.endAt,
      required this.source_,
      this.raw})
      : super._();
  @override
  ApiHealthRecordsPostRequestRecordsInner rebuild(
          void Function(ApiHealthRecordsPostRequestRecordsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiHealthRecordsPostRequestRecordsInnerBuilder toBuilder() =>
      ApiHealthRecordsPostRequestRecordsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiHealthRecordsPostRequestRecordsInner &&
        metric == other.metric &&
        value == other.value &&
        unit == other.unit &&
        startAt == other.startAt &&
        endAt == other.endAt &&
        source_ == other.source_ &&
        raw == other.raw;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metric.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, startAt.hashCode);
    _$hash = $jc(_$hash, endAt.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, raw.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiHealthRecordsPostRequestRecordsInner')
          ..add('metric', metric)
          ..add('value', value)
          ..add('unit', unit)
          ..add('startAt', startAt)
          ..add('endAt', endAt)
          ..add('source_', source_)
          ..add('raw', raw))
        .toString();
  }
}

class ApiHealthRecordsPostRequestRecordsInnerBuilder
    implements
        Builder<ApiHealthRecordsPostRequestRecordsInner,
            ApiHealthRecordsPostRequestRecordsInnerBuilder> {
  _$ApiHealthRecordsPostRequestRecordsInner? _$v;

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

  ApiHealthRecordsPostRequestRecordsInnerBuilder() {
    ApiHealthRecordsPostRequestRecordsInner._defaults(this);
  }

  ApiHealthRecordsPostRequestRecordsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metric = $v.metric;
      _value = $v.value;
      _unit = $v.unit;
      _startAt = $v.startAt;
      _endAt = $v.endAt;
      _source_ = $v.source_;
      _raw = $v.raw?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiHealthRecordsPostRequestRecordsInner other) {
    _$v = other as _$ApiHealthRecordsPostRequestRecordsInner;
  }

  @override
  void update(
      void Function(ApiHealthRecordsPostRequestRecordsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiHealthRecordsPostRequestRecordsInner build() => _build();

  _$ApiHealthRecordsPostRequestRecordsInner _build() {
    _$ApiHealthRecordsPostRequestRecordsInner _$result;
    try {
      _$result = _$v ??
          _$ApiHealthRecordsPostRequestRecordsInner._(
            metric: BuiltValueNullFieldError.checkNotNull(
                metric, r'ApiHealthRecordsPostRequestRecordsInner', 'metric'),
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'ApiHealthRecordsPostRequestRecordsInner', 'value'),
            unit: BuiltValueNullFieldError.checkNotNull(
                unit, r'ApiHealthRecordsPostRequestRecordsInner', 'unit'),
            startAt: BuiltValueNullFieldError.checkNotNull(
                startAt, r'ApiHealthRecordsPostRequestRecordsInner', 'startAt'),
            endAt: endAt,
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'ApiHealthRecordsPostRequestRecordsInner', 'source_'),
            raw: _raw?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'raw';
        _raw?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiHealthRecordsPostRequestRecordsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
