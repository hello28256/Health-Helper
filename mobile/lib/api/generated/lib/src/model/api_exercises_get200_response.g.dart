// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exercises_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiExercisesGet200Response extends ApiExercisesGet200Response {
  @override
  final BuiltList<ExerciseRecord>? records;

  factory _$ApiExercisesGet200Response(
          [void Function(ApiExercisesGet200ResponseBuilder)? updates]) =>
      (ApiExercisesGet200ResponseBuilder()..update(updates))._build();

  _$ApiExercisesGet200Response._({this.records}) : super._();
  @override
  ApiExercisesGet200Response rebuild(
          void Function(ApiExercisesGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiExercisesGet200ResponseBuilder toBuilder() =>
      ApiExercisesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiExercisesGet200Response && records == other.records;
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
    return (newBuiltValueToStringHelper(r'ApiExercisesGet200Response')
          ..add('records', records))
        .toString();
  }
}

class ApiExercisesGet200ResponseBuilder
    implements
        Builder<ApiExercisesGet200Response, ApiExercisesGet200ResponseBuilder> {
  _$ApiExercisesGet200Response? _$v;

  ListBuilder<ExerciseRecord>? _records;
  ListBuilder<ExerciseRecord> get records =>
      _$this._records ??= ListBuilder<ExerciseRecord>();
  set records(ListBuilder<ExerciseRecord>? records) =>
      _$this._records = records;

  ApiExercisesGet200ResponseBuilder() {
    ApiExercisesGet200Response._defaults(this);
  }

  ApiExercisesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiExercisesGet200Response other) {
    _$v = other as _$ApiExercisesGet200Response;
  }

  @override
  void update(void Function(ApiExercisesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiExercisesGet200Response build() => _build();

  _$ApiExercisesGet200Response _build() {
    _$ApiExercisesGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiExercisesGet200Response._(
            records: _records?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        _records?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiExercisesGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
