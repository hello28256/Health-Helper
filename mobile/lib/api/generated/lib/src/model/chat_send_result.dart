// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/chat_message.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_send_result.g.dart';

/// ChatSendResult
///
/// Properties:
/// * [userMessage] 
/// * [assistantMessage] 
@BuiltValue()
abstract class ChatSendResult implements Built<ChatSendResult, ChatSendResultBuilder> {
  @BuiltValueField(wireName: r'userMessage')
  ChatMessage? get userMessage;

  @BuiltValueField(wireName: r'assistantMessage')
  ChatMessage? get assistantMessage;

  ChatSendResult._();

  factory ChatSendResult([void updates(ChatSendResultBuilder b)]) = _$ChatSendResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatSendResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatSendResult> get serializer => _$ChatSendResultSerializer();
}

class _$ChatSendResultSerializer implements PrimitiveSerializer<ChatSendResult> {
  @override
  final Iterable<Type> types = const [ChatSendResult, _$ChatSendResult];

  @override
  final String wireName = r'ChatSendResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatSendResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userMessage != null) {
      yield r'userMessage';
      yield serializers.serialize(
        object.userMessage,
        specifiedType: const FullType(ChatMessage),
      );
    }
    if (object.assistantMessage != null) {
      yield r'assistantMessage';
      yield serializers.serialize(
        object.assistantMessage,
        specifiedType: const FullType(ChatMessage),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatSendResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatSendResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessage),
          ) as ChatMessage;
          result.userMessage.replace(valueDes);
          break;
        case r'assistantMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessage),
          ) as ChatMessage;
          result.assistantMessage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatSendResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatSendResultBuilder();
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

