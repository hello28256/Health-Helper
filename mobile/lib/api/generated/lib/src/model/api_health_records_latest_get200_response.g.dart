// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_health_records_latest_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiHealthRecordsLatestGet200Response
    extends ApiHealthRecordsLatestGet200Response {
  @override
  final HealthRecord? record;

  factory _$ApiHealthRecordsLatestGet200Response(
          [void Function(ApiHealthRecordsLatestGet200ResponseBuilder)?
              updates]) =>
      (ApiHealthRecordsLatestGet200ResponseBuilder()..update(updates))._build();

  _$ApiHealthRecordsLatestGet200Response._({this.record}) : super._();
  @override
  ApiHealthRecordsLatestGet200Response rebuild(
          void Function(ApiHealthRecordsLatestGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiHealthRecordsLatestGet200ResponseBuilder toBuilder() =>
      ApiHealthRecordsLatestGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiHealthRecordsLatestGet200Response &&
        record == other.record;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, record.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiHealthRecordsLatestGet200Response')
          ..add('record', record))
        .toString();
  }
}

class ApiHealthRecordsLatestGet200ResponseBuilder
    implements
        Builder<ApiHealthRecordsLatestGet200Response,
            ApiHealthRecordsLatestGet200ResponseBuilder> {
  _$ApiHealthRecordsLatestGet200Response? _$v;

  HealthRecordBuilder? _record;
  HealthRecordBuilder get record => _$this._record ??= HealthRecordBuilder();
  set record(HealthRecordBuilder? record) => _$this._record = record;

  ApiHealthRecordsLatestGet200ResponseBuilder() {
    ApiHealthRecordsLatestGet200Response._defaults(this);
  }

  ApiHealthRecordsLatestGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _record = $v.record?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiHealthRecordsLatestGet200Response other) {
    _$v = other as _$ApiHealthRecordsLatestGet200Response;
  }

  @override
  void update(
      void Function(ApiHealthRecordsLatestGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiHealthRecordsLatestGet200Response build() => _build();

  _$ApiHealthRecordsLatestGet200Response _build() {
    _$ApiHealthRecordsLatestGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiHealthRecordsLatestGet200Response._(
            record: _record?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'record';
        _record?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiHealthRecordsLatestGet200Response',
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
