// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_diet_records_post_request.g.dart';

/// ApiDietRecordsPostRequest
///
/// Properties:
/// * [foodId] 
/// * [mealType] 
/// * [consumedAt] 
/// * [servings] 
@BuiltValue()
abstract class ApiDietRecordsPostRequest implements Built<ApiDietRecordsPostRequest, ApiDietRecordsPostRequestBuilder> {
  @BuiltValueField(wireName: r'foodId')
  int get foodId;

  @BuiltValueField(wireName: r'mealType')
  ApiDietRecordsPostRequestMealTypeEnum get mealType;
  // enum mealTypeEnum {  breakfast,  lunch,  dinner,  snack,  };

  @BuiltValueField(wireName: r'consumedAt')
  DateTime? get consumedAt;

  @BuiltValueField(wireName: r'servings')
  num get servings;

  ApiDietRecordsPostRequest._();

  factory ApiDietRecordsPostRequest([void updates(ApiDietRecordsPostRequestBuilder b)]) = _$ApiDietRecordsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiDietRecordsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiDietRecordsPostRequest> get serializer => _$ApiDietRecordsPostRequestSerializer();
}

class _$ApiDietRecordsPostRequestSerializer implements PrimitiveSerializer<ApiDietRecordsPostRequest> {
  @override
  final Iterable<Type> types = const [ApiDietRecordsPostRequest, _$ApiDietRecordsPostRequest];

  @override
  final String wireName = r'ApiDietRecordsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiDietRecordsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'foodId';
    yield serializers.serialize(
      object.foodId,
      specifiedType: const FullType(int),
    );
    yield r'mealType';
    yield serializers.serialize(
      object.mealType,
      specifiedType: const FullType(ApiDietRecordsPostRequestMealTypeEnum),
    );
    if (object.consumedAt != null) {
      yield r'consumedAt';
      yield serializers.serialize(
        object.consumedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'servings';
    yield serializers.serialize(
      object.servings,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiDietRecordsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiDietRecordsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'foodId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.foodId = valueDes;
          break;
        case r'mealType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiDietRecordsPostRequestMealTypeEnum),
          ) as ApiDietRecordsPostRequestMealTypeEnum;
          result.mealType = valueDes;
          break;
        case r'consumedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.consumedAt = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.servings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiDietRecordsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiDietRecordsPostRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class ApiDietRecordsPostRequestMealTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'breakfast')
  static const ApiDietRecordsPostRequestMealTypeEnum breakfast = _$apiDietRecordsPostRequestMealTypeEnum_breakfast;
  @BuiltValueEnumConst(wireName: r'lunch')
  static const ApiDietRecordsPostRequestMealTypeEnum lunch = _$apiDietRecordsPostRequestMealTypeEnum_lunch;
  @BuiltValueEnumConst(wireName: r'dinner')
  static const ApiDietRecordsPostRequestMealTypeEnum dinner = _$apiDietRecordsPostRequestMealTypeEnum_dinner;
  @BuiltValueEnumConst(wireName: r'snack')
  static const ApiDietRecordsPostRequestMealTypeEnum snack = _$apiDietRecordsPostRequestMealTypeEnum_snack;

  static Serializer<ApiDietRecordsPostRequestMealTypeEnum> get serializer => _$apiDietRecordsPostRequestMealTypeEnumSerializer;

  const ApiDietRecordsPostRequestMealTypeEnum._(String name): super(name);

  static BuiltSet<ApiDietRecordsPostRequestMealTypeEnum> get values => _$apiDietRecordsPostRequestMealTypeEnumValues;
  static ApiDietRecordsPostRequestMealTypeEnum valueOf(String name) => _$apiDietRecordsPostRequestMealTypeEnumValueOf(name);
}

