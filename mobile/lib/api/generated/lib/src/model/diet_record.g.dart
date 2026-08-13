// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DietRecordMealTypeEnum _$dietRecordMealTypeEnum_breakfast =
    const DietRecordMealTypeEnum._('breakfast');
const DietRecordMealTypeEnum _$dietRecordMealTypeEnum_lunch =
    const DietRecordMealTypeEnum._('lunch');
const DietRecordMealTypeEnum _$dietRecordMealTypeEnum_dinner =
    const DietRecordMealTypeEnum._('dinner');
const DietRecordMealTypeEnum _$dietRecordMealTypeEnum_snack =
    const DietRecordMealTypeEnum._('snack');

DietRecordMealTypeEnum _$dietRecordMealTypeEnumValueOf(String name) {
  switch (name) {
    case 'breakfast':
      return _$dietRecordMealTypeEnum_breakfast;
    case 'lunch':
      return _$dietRecordMealTypeEnum_lunch;
    case 'dinner':
      return _$dietRecordMealTypeEnum_dinner;
    case 'snack':
      return _$dietRecordMealTypeEnum_snack;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DietRecordMealTypeEnum> _$dietRecordMealTypeEnumValues =
    BuiltSet<DietRecordMealTypeEnum>(const <DietRecordMealTypeEnum>[
  _$dietRecordMealTypeEnum_breakfast,
  _$dietRecordMealTypeEnum_lunch,
  _$dietRecordMealTypeEnum_dinner,
  _$dietRecordMealTypeEnum_snack,
]);

Serializer<DietRecordMealTypeEnum> _$dietRecordMealTypeEnumSerializer =
    _$DietRecordMealTypeEnumSerializer();

class _$DietRecordMealTypeEnumSerializer
    implements PrimitiveSerializer<DietRecordMealTypeEnum> {
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
  final Iterable<Type> types = const <Type>[DietRecordMealTypeEnum];
  @override
  final String wireName = 'DietRecordMealTypeEnum';

  @override
  Object serialize(Serializers serializers, DietRecordMealTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DietRecordMealTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DietRecordMealTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DietRecord extends DietRecord {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final int? foodId;
  @override
  final DietRecordMealTypeEnum? mealType;
  @override
  final DateTime? consumedAt;
  @override
  final num? servings;
  @override
  final Food? food;
  @override
  final DietRecordConsumed? consumed;

  factory _$DietRecord([void Function(DietRecordBuilder)? updates]) =>
      (DietRecordBuilder()..update(updates))._build();

  _$DietRecord._(
      {this.id,
      this.userId,
      this.foodId,
      this.mealType,
      this.consumedAt,
      this.servings,
      this.food,
      this.consumed})
      : super._();
  @override
  DietRecord rebuild(void Function(DietRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietRecordBuilder toBuilder() => DietRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietRecord &&
        id == other.id &&
        userId == other.userId &&
        foodId == other.foodId &&
        mealType == other.mealType &&
        consumedAt == other.consumedAt &&
        servings == other.servings &&
        food == other.food &&
        consumed == other.consumed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, foodId.hashCode);
    _$hash = $jc(_$hash, mealType.hashCode);
    _$hash = $jc(_$hash, consumedAt.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, consumed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietRecord')
          ..add('id', id)
          ..add('userId', userId)
          ..add('foodId', foodId)
          ..add('mealType', mealType)
          ..add('consumedAt', consumedAt)
          ..add('servings', servings)
          ..add('food', food)
          ..add('consumed', consumed))
        .toString();
  }
}

class DietRecordBuilder implements Builder<DietRecord, DietRecordBuilder> {
  _$DietRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  int? _foodId;
  int? get foodId => _$this._foodId;
  set foodId(int? foodId) => _$this._foodId = foodId;

  DietRecordMealTypeEnum? _mealType;
  DietRecordMealTypeEnum? get mealType => _$this._mealType;
  set mealType(DietRecordMealTypeEnum? mealType) => _$this._mealType = mealType;

  DateTime? _consumedAt;
  DateTime? get consumedAt => _$this._consumedAt;
  set consumedAt(DateTime? consumedAt) => _$this._consumedAt = consumedAt;

  num? _servings;
  num? get servings => _$this._servings;
  set servings(num? servings) => _$this._servings = servings;

  FoodBuilder? _food;
  FoodBuilder get food => _$this._food ??= FoodBuilder();
  set food(FoodBuilder? food) => _$this._food = food;

  DietRecordConsumedBuilder? _consumed;
  DietRecordConsumedBuilder get consumed =>
      _$this._consumed ??= DietRecordConsumedBuilder();
  set consumed(DietRecordConsumedBuilder? consumed) =>
      _$this._consumed = consumed;

  DietRecordBuilder() {
    DietRecord._defaults(this);
  }

  DietRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _foodId = $v.foodId;
      _mealType = $v.mealType;
      _consumedAt = $v.consumedAt;
      _servings = $v.servings;
      _food = $v.food?.toBuilder();
      _consumed = $v.consumed?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietRecord other) {
    _$v = other as _$DietRecord;
  }

  @override
  void update(void Function(DietRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietRecord build() => _build();

  _$DietRecord _build() {
    _$DietRecord _$result;
    try {
      _$result = _$v ??
          _$DietRecord._(
            id: id,
            userId: userId,
            foodId: foodId,
            mealType: mealType,
            consumedAt: consumedAt,
            servings: servings,
            food: _food?.build(),
            consumed: _consumed?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'food';
        _food?.build();
        _$failedField = 'consumed';
        _consumed?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
