// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/food.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_diet_foods_get200_response.g.dart';

/// ApiDietFoodsGet200Response
///
/// Properties:
/// * [foods] 
@BuiltValue()
abstract class ApiDietFoodsGet200Response implements Built<ApiDietFoodsGet200Response, ApiDietFoodsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'foods')
  BuiltList<Food>? get foods;

  ApiDietFoodsGet200Response._();

  factory ApiDietFoodsGet200Response([void updates(ApiDietFoodsGet200ResponseBuilder b)]) = _$ApiDietFoodsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiDietFoodsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiDietFoodsGet200Response> get serializer => _$ApiDietFoodsGet200ResponseSerializer();
}

class _$ApiDietFoodsGet200ResponseSerializer implements PrimitiveSerializer<ApiDietFoodsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiDietFoodsGet200Response, _$ApiDietFoodsGet200Response];

  @override
  final String wireName = r'ApiDietFoodsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiDietFoodsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.foods != null) {
      yield r'foods';
      yield serializers.serialize(
        object.foods,
        specifiedType: const FullType(BuiltList, [FullType(Food)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiDietFoodsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiDietFoodsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'foods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Food)]),
          ) as BuiltList<Food>;
          result.foods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiDietFoodsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiDietFoodsGet200ResponseBuilder();
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

