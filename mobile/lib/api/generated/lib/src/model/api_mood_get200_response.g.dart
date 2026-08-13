// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_mood_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiMoodGet200Response extends ApiMoodGet200Response {
  @override
  final BuiltList<MoodRecord>? records;

  factory _$ApiMoodGet200Response(
          [void Function(ApiMoodGet200ResponseBuilder)? updates]) =>
      (ApiMoodGet200ResponseBuilder()..update(updates))._build();

  _$ApiMoodGet200Response._({this.records}) : super._();
  @override
  ApiMoodGet200Response rebuild(
          void Function(ApiMoodGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiMoodGet200ResponseBuilder toBuilder() =>
      ApiMoodGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiMoodGet200Response && records == other.records;
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
    return (newBuiltValueToStringHelper(r'ApiMoodGet200Response')
          ..add('records', records))
        .toString();
  }
}

class ApiMoodGet200ResponseBuilder
    implements Builder<ApiMoodGet200Response, ApiMoodGet200ResponseBuilder> {
  _$ApiMoodGet200Response? _$v;

  ListBuilder<MoodRecord>? _records;
  ListBuilder<MoodRecord> get records =>
      _$this._records ??= ListBuilder<MoodRecord>();
  set records(ListBuilder<MoodRecord>? records) => _$this._records = records;

  ApiMoodGet200ResponseBuilder() {
    ApiMoodGet200Response._defaults(this);
  }

  ApiMoodGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiMoodGet200Response other) {
    _$v = other as _$ApiMoodGet200Response;
  }

  @override
  void update(void Function(ApiMoodGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiMoodGet200Response build() => _build();

  _$ApiMoodGet200Response _build() {
    _$ApiMoodGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiMoodGet200Response._(
            records: _records?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        _records?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiMoodGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
