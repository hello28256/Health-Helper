// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_health_records_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiHealthRecordsGet200Response extends ApiHealthRecordsGet200Response {
  @override
  final BuiltList<HealthRecord>? records;

  factory _$ApiHealthRecordsGet200Response(
          [void Function(ApiHealthRecordsGet200ResponseBuilder)? updates]) =>
      (ApiHealthRecordsGet200ResponseBuilder()..update(updates))._build();

  _$ApiHealthRecordsGet200Response._({this.records}) : super._();
  @override
  ApiHealthRecordsGet200Response rebuild(
          void Function(ApiHealthRecordsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiHealthRecordsGet200ResponseBuilder toBuilder() =>
      ApiHealthRecordsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiHealthRecordsGet200Response && records == other.records;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiHealthRecordsGet200Response')
          ..add('records', records))
        .toString();
  }
}

class ApiHealthRecordsGet200ResponseBuilder
    implements
        Builder<ApiHealthRecordsGet200Response,
            ApiHealthRecordsGet200ResponseBuilder> {
  _$ApiHealthRecordsGet200Response? _$v;

  ListBuilder<HealthRecord>? _records;
  ListBuilder<HealthRecord> get records =>
      _$this._records ??= ListBuilder<HealthRecord>();
  set records(ListBuilder<HealthRecord>? records) => _$this._records = records;

  ApiHealthRecordsGet200ResponseBuilder() {
    ApiHealthRecordsGet200Response._defaults(this);
  }

  ApiHealthRecordsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiHealthRecordsGet200Response other) {
    _$v = other as _$ApiHealthRecordsGet200Response;
  }

  @override
  void update(void Function(ApiHealthRecordsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiHealthRecordsGet200Response build() => _build();

  _$ApiHealthRecordsGet200Response _build() {
    _$ApiHealthRecordsGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiHealthRecordsGet200Response._(
            records: _records?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        _records?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiHealthRecordsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
