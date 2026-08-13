// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_diet_records_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiDietRecordsGet200Response extends ApiDietRecordsGet200Response {
  @override
  final BuiltList<DietRecord>? records;

  factory _$ApiDietRecordsGet200Response(
          [void Function(ApiDietRecordsGet200ResponseBuilder)? updates]) =>
      (ApiDietRecordsGet200ResponseBuilder()..update(updates))._build();

  _$ApiDietRecordsGet200Response._({this.records}) : super._();
  @override
  ApiDietRecordsGet200Response rebuild(
          void Function(ApiDietRecordsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiDietRecordsGet200ResponseBuilder toBuilder() =>
      ApiDietRecordsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiDietRecordsGet200Response && records == other.records;
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
    return (newBuiltValueToStringHelper(r'ApiDietRecordsGet200Response')
          ..add('records', records))
        .toString();
  }
}

class ApiDietRecordsGet200ResponseBuilder
    implements
        Builder<ApiDietRecordsGet200Response,
            ApiDietRecordsGet200ResponseBuilder> {
  _$ApiDietRecordsGet200Response? _$v;

  ListBuilder<DietRecord>? _records;
  ListBuilder<DietRecord> get records =>
      _$this._records ??= ListBuilder<DietRecord>();
  set records(ListBuilder<DietRecord>? records) => _$this._records = records;

  ApiDietRecordsGet200ResponseBuilder() {
    ApiDietRecordsGet200Response._defaults(this);
  }

  ApiDietRecordsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiDietRecordsGet200Response other) {
    _$v = other as _$ApiDietRecordsGet200Response;
  }

  @override
  void update(void Function(ApiDietRecordsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiDietRecordsGet200Response build() => _build();

  _$ApiDietRecordsGet200Response _build() {
    _$ApiDietRecordsGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiDietRecordsGet200Response._(
            records: _records?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        _records?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiDietRecordsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
