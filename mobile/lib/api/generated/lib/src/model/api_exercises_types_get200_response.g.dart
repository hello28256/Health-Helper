// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exercises_types_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiExercisesTypesGet200Response
    extends ApiExercisesTypesGet200Response {
  @override
  final BuiltList<ExerciseType>? types;

  factory _$ApiExercisesTypesGet200Response(
          [void Function(ApiExercisesTypesGet200ResponseBuilder)? updates]) =>
      (ApiExercisesTypesGet200ResponseBuilder()..update(updates))._build();

  _$ApiExercisesTypesGet200Response._({this.types}) : super._();
  @override
  ApiExercisesTypesGet200Response rebuild(
          void Function(ApiExercisesTypesGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiExercisesTypesGet200ResponseBuilder toBuilder() =>
      ApiExercisesTypesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiExercisesTypesGet200Response && types == other.types;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, types.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiExercisesTypesGet200Response')
          ..add('types', types))
        .toString();
  }
}

class ApiExercisesTypesGet200ResponseBuilder
    implements
        Builder<ApiExercisesTypesGet200Response,
            ApiExercisesTypesGet200ResponseBuilder> {
  _$ApiExercisesTypesGet200Response? _$v;

  ListBuilder<ExerciseType>? _types;
  ListBuilder<ExerciseType> get types =>
      _$this._types ??= ListBuilder<ExerciseType>();
  set types(ListBuilder<ExerciseType>? types) => _$this._types = types;

  ApiExercisesTypesGet200ResponseBuilder() {
    ApiExercisesTypesGet200Response._defaults(this);
  }

  ApiExercisesTypesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _types = $v.types?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiExercisesTypesGet200Response other) {
    _$v = other as _$ApiExercisesTypesGet200Response;
  }

  @override
  void update(void Function(ApiExercisesTypesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiExercisesTypesGet200Response build() => _build();

  _$ApiExercisesTypesGet200Response _build() {
    _$ApiExercisesTypesGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiExercisesTypesGet200Response._(
            types: _types?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'types';
        _types?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiExercisesTypesGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
