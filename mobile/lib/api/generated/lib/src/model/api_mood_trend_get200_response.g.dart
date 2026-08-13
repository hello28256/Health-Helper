// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_mood_trend_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiMoodTrendGet200Response extends ApiMoodTrendGet200Response {
  @override
  final BuiltList<MoodTrendPoint>? trend;

  factory _$ApiMoodTrendGet200Response(
          [void Function(ApiMoodTrendGet200ResponseBuilder)? updates]) =>
      (ApiMoodTrendGet200ResponseBuilder()..update(updates))._build();

  _$ApiMoodTrendGet200Response._({this.trend}) : super._();
  @override
  ApiMoodTrendGet200Response rebuild(
          void Function(ApiMoodTrendGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiMoodTrendGet200ResponseBuilder toBuilder() =>
      ApiMoodTrendGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiMoodTrendGet200Response && trend == other.trend;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trend.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiMoodTrendGet200Response')
          ..add('trend', trend))
        .toString();
  }
}

class ApiMoodTrendGet200ResponseBuilder
    implements
        Builder<ApiMoodTrendGet200Response, ApiMoodTrendGet200ResponseBuilder> {
  _$ApiMoodTrendGet200Response? _$v;

  ListBuilder<MoodTrendPoint>? _trend;
  ListBuilder<MoodTrendPoint> get trend =>
      _$this._trend ??= ListBuilder<MoodTrendPoint>();
  set trend(ListBuilder<MoodTrendPoint>? trend) => _$this._trend = trend;

  ApiMoodTrendGet200ResponseBuilder() {
    ApiMoodTrendGet200Response._defaults(this);
  }

  ApiMoodTrendGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trend = $v.trend?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiMoodTrendGet200Response other) {
    _$v = other as _$ApiMoodTrendGet200Response;
  }

  @override
  void update(void Function(ApiMoodTrendGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiMoodTrendGet200Response build() => _build();

  _$ApiMoodTrendGet200Response _build() {
    _$ApiMoodTrendGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiMoodTrendGet200Response._(
            trend: _trend?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'trend';
        _trend?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiMoodTrendGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
