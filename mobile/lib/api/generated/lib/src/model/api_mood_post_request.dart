// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_mood_post_request.g.dart';

/// ApiMoodPostRequest
///
/// Properties:
/// * [mood] 
/// * [score] 
/// * [note] 
/// * [recordedAt] 
@BuiltValue()
abstract class ApiMoodPostRequest implements Built<ApiMoodPostRequest, ApiMoodPostRequestBuilder> {
  @BuiltValueField(wireName: r'mood')
  ApiMoodPostRequestMoodEnum get mood;
  // enum moodEnum {  happy,  calm,  sad,  anxious,  angry,  tired,  grateful,  excited,  };

  @BuiltValueField(wireName: r'score')
  int? get score;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime? get recordedAt;

  ApiMoodPostRequest._();

  factory ApiMoodPostRequest([void updates(ApiMoodPostRequestBuilder b)]) = _$ApiMoodPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiMoodPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiMoodPostRequest> get serializer => _$ApiMoodPostRequestSerializer();
}

class _$ApiMoodPostRequestSerializer implements PrimitiveSerializer<ApiMoodPostRequest> {
  @override
  final Iterable<Type> types = const [ApiMoodPostRequest, _$ApiMoodPostRequest];

  @override
  final String wireName = r'ApiMoodPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiMoodPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mood';
    yield serializers.serialize(
      object.mood,
      specifiedType: const FullType(ApiMoodPostRequestMoodEnum),
    );
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType(int),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.recordedAt != null) {
      yield r'recordedAt';
      yield serializers.serialize(
        object.recordedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiMoodPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiMoodPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiMoodPostRequestMoodEnum),
          ) as ApiMoodPostRequestMoodEnum;
          result.mood = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.score = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        case r'recordedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiMoodPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiMoodPostRequestBuilder();
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

class ApiMoodPostRequestMoodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'happy')
  static const ApiMoodPostRequestMoodEnum happy = _$apiMoodPostRequestMoodEnum_happy;
  @BuiltValueEnumConst(wireName: r'calm')
  static const ApiMoodPostRequestMoodEnum calm = _$apiMoodPostRequestMoodEnum_calm;
  @BuiltValueEnumConst(wireName: r'sad')
  static const ApiMoodPostRequestMoodEnum sad = _$apiMoodPostRequestMoodEnum_sad;
  @BuiltValueEnumConst(wireName: r'anxious')
  static const ApiMoodPostRequestMoodEnum anxious = _$apiMoodPostRequestMoodEnum_anxious;
  @BuiltValueEnumConst(wireName: r'angry')
  static const ApiMoodPostRequestMoodEnum angry = _$apiMoodPostRequestMoodEnum_angry;
  @BuiltValueEnumConst(wireName: r'tired')
  static const ApiMoodPostRequestMoodEnum tired = _$apiMoodPostRequestMoodEnum_tired;
  @BuiltValueEnumConst(wireName: r'grateful')
  static const ApiMoodPostRequestMoodEnum grateful = _$apiMoodPostRequestMoodEnum_grateful;
  @BuiltValueEnumConst(wireName: r'excited')
  static const ApiMoodPostRequestMoodEnum excited = _$apiMoodPostRequestMoodEnum_excited;

  static Serializer<ApiMoodPostRequestMoodEnum> get serializer => _$apiMoodPostRequestMoodEnumSerializer;

  const ApiMoodPostRequestMoodEnum._(String name): super(name);

  static BuiltSet<ApiMoodPostRequestMoodEnum> get values => _$apiMoodPostRequestMoodEnumValues;
  static ApiMoodPostRequestMoodEnum valueOf(String name) => _$apiMoodPostRequestMoodEnumValueOf(name);
}

