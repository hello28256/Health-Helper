// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_diet_foods_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiDietFoodsGet200Response extends ApiDietFoodsGet200Response {
  @override
  final BuiltList<Food>? foods;

  factory _$ApiDietFoodsGet200Response(
          [void Function(ApiDietFoodsGet200ResponseBuilder)? updates]) =>
      (ApiDietFoodsGet200ResponseBuilder()..update(updates))._build();

  _$ApiDietFoodsGet200Response._({this.foods}) : super._();
  @override
  ApiDietFoodsGet200Response rebuild(
          void Function(ApiDietFoodsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiDietFoodsGet200ResponseBuilder toBuilder() =>
      ApiDietFoodsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiDietFoodsGet200Response && foods == other.foods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, foods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiDietFoodsGet200Response')
          ..add('foods', foods))
        .toString();
  }
}

class ApiDietFoodsGet200ResponseBuilder
    implements
        Builder<ApiDietFoodsGet200Response, ApiDietFoodsGet200ResponseBuilder> {
  _$ApiDietFoodsGet200Response? _$v;

  ListBuilder<Food>? _foods;
  ListBuilder<Food> get foods => _$this._foods ??= ListBuilder<Food>();
  set foods(ListBuilder<Food>? foods) => _$this._foods = foods;

  ApiDietFoodsGet200ResponseBuilder() {
    ApiDietFoodsGet200Response._defaults(this);
  }

  ApiDietFoodsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _foods = $v.foods?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiDietFoodsGet200Response other) {
    _$v = other as _$ApiDietFoodsGet200Response;
  }

  @override
  void update(void Function(ApiDietFoodsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiDietFoodsGet200Response build() => _build();

  _$ApiDietFoodsGet200Response _build() {
    _$ApiDietFoodsGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiDietFoodsGet200Response._(
            foods: _foods?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'foods';
        _foods?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiDietFoodsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
