// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/chat_message.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_chat_history_get200_response.g.dart';

/// ApiChatHistoryGet200Response
///
/// Properties:
/// * [history] 
@BuiltValue()
abstract class ApiChatHistoryGet200Response implements Built<ApiChatHistoryGet200Response, ApiChatHistoryGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'history')
  BuiltList<ChatMessage>? get history;

  ApiChatHistoryGet200Response._();

  factory ApiChatHistoryGet200Response([void updates(ApiChatHistoryGet200ResponseBuilder b)]) = _$ApiChatHistoryGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiChatHistoryGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiChatHistoryGet200Response> get serializer => _$ApiChatHistoryGet200ResponseSerializer();
}

class _$ApiChatHistoryGet200ResponseSerializer implements PrimitiveSerializer<ApiChatHistoryGet200Response> {
  @override
  final Iterable<Type> types = const [ApiChatHistoryGet200Response, _$ApiChatHistoryGet200Response];

  @override
  final String wireName = r'ApiChatHistoryGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiChatHistoryGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.history != null) {
      yield r'history';
      yield serializers.serialize(
        object.history,
        specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiChatHistoryGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiChatHistoryGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
          ) as BuiltList<ChatMessage>;
          result.history.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiChatHistoryGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiChatHistoryGet200ResponseBuilder();
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

