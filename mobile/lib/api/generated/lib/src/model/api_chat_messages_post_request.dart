// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_chat_messages_post_request.g.dart';

/// ApiChatMessagesPostRequest
///
/// Properties:
/// * [content] 
@BuiltValue()
abstract class ApiChatMessagesPostRequest implements Built<ApiChatMessagesPostRequest, ApiChatMessagesPostRequestBuilder> {
  @BuiltValueField(wireName: r'content')
  String get content;

  ApiChatMessagesPostRequest._();

  factory ApiChatMessagesPostRequest([void updates(ApiChatMessagesPostRequestBuilder b)]) = _$ApiChatMessagesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiChatMessagesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiChatMessagesPostRequest> get serializer => _$ApiChatMessagesPostRequestSerializer();
}

class _$ApiChatMessagesPostRequestSerializer implements PrimitiveSerializer<ApiChatMessagesPostRequest> {
  @override
  final Iterable<Type> types = const [ApiChatMessagesPostRequest, _$ApiChatMessagesPostRequest];

  @override
  final String wireName = r'ApiChatMessagesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiChatMessagesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'content';
    yield serializers.serialize(
      object.content,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiChatMessagesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiChatMessagesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.content = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiChatMessagesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiChatMessagesPostRequestBuilder();
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

