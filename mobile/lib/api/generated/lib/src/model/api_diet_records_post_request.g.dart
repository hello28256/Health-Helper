// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_diet_records_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiDietRecordsPostRequestMealTypeEnum
    _$apiDietRecordsPostRequestMealTypeEnum_breakfast =
    const ApiDietRecordsPostRequestMealTypeEnum._('breakfast');
const ApiDietRecordsPostRequestMealTypeEnum
    _$apiDietRecordsPostRequestMealTypeEnum_lunch =
    const ApiDietRecordsPostRequestMealTypeEnum._('lunch');
const ApiDietRecordsPostRequestMealTypeEnum
    _$apiDietRecordsPostRequestMealTypeEnum_dinner =
    const ApiDietRecordsPostRequestMealTypeEnum._('dinner');
const ApiDietRecordsPostRequestMealTypeEnum
    _$apiDietRecordsPostRequestMealTypeEnum_snack =
    const ApiDietRecordsPostRequestMealTypeEnum._('snack');

ApiDietRecordsPostRequestMealTypeEnum
    _$apiDietRecordsPostRequestMealTypeEnumValueOf(String name) {
  switch (name) {
    case 'breakfast':
      return _$apiDietRecordsPostRequestMealTypeEnum_breakfast;
    case 'lunch':
      return _$apiDietRecordsPostRequestMealTypeEnum_lunch;
    case 'dinner':
      return _$apiDietRecordsPostRequestMealTypeEnum_dinner;
    case 'snack':
      return _$apiDietRecordsPostRequestMealTypeEnum_snack;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiDietRecordsPostRequestMealTypeEnum>
    _$apiDietRecordsPostRequestMealTypeEnumValues = BuiltSet<
        ApiDietRecordsPostRequestMealTypeEnum>(const <ApiDietRecordsPostRequestMealTypeEnum>[
  _$apiDietRecordsPostRequestMealTypeEnum_breakfast,
  _$apiDietRecordsPostRequestMealTypeEnum_lunch,
  _$apiDietRecordsPostRequestMealTypeEnum_dinner,
  _$apiDietRecordsPostRequestMealTypeEnum_snack,
]);

Serializer<ApiDietRecordsPostRequestMealTypeEnum>
    _$apiDietRecordsPostRequestMealTypeEnumSerializer =
    _$ApiDietRecordsPostRequestMealTypeEnumSerializer();

class _$ApiDietRecordsPostRequestMealTypeEnumSerializer
    implements PrimitiveSerializer<ApiDietRecordsPostRequestMealTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'breakfast': 'breakfast',
    'lunch': 'lunch',
    'dinner': 'dinner',
    'snack': 'snack',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'breakfast': 'breakfast',
    'lunch': 'lunch',
    'dinner': 'dinner',
    'snack': 'snack',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiDietRecordsPostRequestMealTypeEnum
  ];
  @override
  final String wireName = 'ApiDietRecordsPostRequestMealTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ApiDietRecordsPostRequestMealTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiDietRecordsPostRequestMealTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiDietRecordsPostRequestMealTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiDietRecordsPostRequest extends ApiDietRecordsPostRequest {
  @override
  final int foodId;
  @override
  final ApiDietRecordsPostRequestMealTypeEnum mealType;
  @override
  final DateTime? consumedAt;
  @override
  final num servings;

  factory _$ApiDietRecordsPostRequest(
          [void Function(ApiDietRecordsPostRequestBuilder)? updates]) =>
      (ApiDietRecordsPostRequestBuilder()..update(updates))._build();

  _$ApiDietRecordsPostRequest._(
      {required this.foodId,
      required this.mealType,
      this.consumedAt,
      required this.servings})
      : super._();
  @override
  ApiDietRecordsPostRequest rebuild(
          void Function(ApiDietRecordsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiDietRecordsPostRequestBuilder toBuilder() =>
      ApiDietRecordsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiDietRecordsPostRequest &&
        foodId == other.foodId &&
        mealType == other.mealType &&
        consumedAt == other.consumedAt &&
        servings == other.servings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, foodId.hashCode);
    _$hash = $jc(_$hash, mealType.hashCode);
    _$hash = $jc(_$hash, consumedAt.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiDietRecordsPostRequest')
          ..add('foodId', foodId)
          ..add('mealType', mealType)
          ..add('consumedAt', consumedAt)
          ..add('servings', servings))
        .toString();
  }
}

class ApiDietRecordsPostRequestBuilder
    implements
        Builder<ApiDietRecordsPostRequest, ApiDietRecordsPostRequestBuilder> {
  _$ApiDietRecordsPostRequest? _$v;

  int? _foodId;
  int? get foodId => _$this._foodId;
  set foodId(int? foodId) => _$this._foodId = foodId;

  ApiDietRecordsPostRequestMealTypeEnum? _mealType;
  ApiDietRecordsPostRequestMealTypeEnum? get mealType => _$this._mealType;
  set mealType(ApiDietRecordsPostRequestMealTypeEnum? mealType) =>
      _$this._mealType = mealType;

  DateTime? _consumedAt;
  DateTime? get consumedAt => _$this._consumedAt;
  set consumedAt(DateTime? consumedAt) => _$this._consumedAt = consumedAt;

  num? _servings;
  num? get servings => _$this._servings;
  set servings(num? servings) => _$this._servings = servings;

  ApiDietRecordsPostRequestBuilder() {
    ApiDietRecordsPostRequest._defaults(this);
  }

  ApiDietRecordsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _foodId = $v.foodId;
      _mealType = $v.mealType;
      _consumedAt = $v.consumedAt;
      _servings = $v.servings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiDietRecordsPostRequest other) {
    _$v = other as _$ApiDietRecordsPostRequest;
  }

  @override
  void update(void Function(ApiDietRecordsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiDietRecordsPostRequest build() => _build();

  _$ApiDietRecordsPostRequest _build() {
    final _$result = _$v ??
        _$ApiDietRecordsPostRequest._(
          foodId: BuiltValueNullFieldError.checkNotNull(
              foodId, r'ApiDietRecordsPostRequest', 'foodId'),
          mealType: BuiltValueNullFieldError.checkNotNull(
              mealType, r'ApiDietRecordsPostRequest', 'mealType'),
          consumedAt: consumedAt,
          servings: BuiltValueNullFieldError.checkNotNull(
              servings, r'ApiDietRecordsPostRequest', 'servings'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
