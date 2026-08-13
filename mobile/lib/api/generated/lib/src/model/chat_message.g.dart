// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatMessageRoleEnum _$chatMessageRoleEnum_user =
    const ChatMessageRoleEnum._('user');
const ChatMessageRoleEnum _$chatMessageRoleEnum_assistant =
    const ChatMessageRoleEnum._('assistant');

ChatMessageRoleEnum _$chatMessageRoleEnumValueOf(String name) {
  switch (name) {
    case 'user':
      return _$chatMessageRoleEnum_user;
    case 'assistant':
      return _$chatMessageRoleEnum_assistant;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatMessageRoleEnum> _$chatMessageRoleEnumValues =
    BuiltSet<ChatMessageRoleEnum>(const <ChatMessageRoleEnum>[
  _$chatMessageRoleEnum_user,
  _$chatMessageRoleEnum_assistant,
]);

Serializer<ChatMessageRoleEnum> _$chatMessageRoleEnumSerializer =
    _$ChatMessageRoleEnumSerializer();

class _$ChatMessageRoleEnumSerializer
    implements PrimitiveSerializer<ChatMessageRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'user': 'user',
    'assistant': 'assistant',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'user': 'user',
    'assistant': 'assistant',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatMessageRoleEnum];
  @override
  final String wireName = 'ChatMessageRoleEnum';

  @override
  Object serialize(Serializers serializers, ChatMessageRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatMessageRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatMessageRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatMessage extends ChatMessage {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final ChatMessageRoleEnum? role;
  @override
  final String? content;
  @override
  final DateTime? createdAt;

  factory _$ChatMessage([void Function(ChatMessageBuilder)? updates]) =>
      (ChatMessageBuilder()..update(updates))._build();

  _$ChatMessage._(
      {this.id, this.userId, this.role, this.content, this.createdAt})
      : super._();
  @override
  ChatMessage rebuild(void Function(ChatMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageBuilder toBuilder() => ChatMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
        id == other.id &&
        userId == other.userId &&
        role == other.role &&
        content == other.content &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessage')
          ..add('id', id)
          ..add('userId', userId)
          ..add('role', role)
          ..add('content', content)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ChatMessageBuilder implements Builder<ChatMessage, ChatMessageBuilder> {
  _$ChatMessage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  ChatMessageRoleEnum? _role;
  ChatMessageRoleEnum? get role => _$this._role;
  set role(ChatMessageRoleEnum? role) => _$this._role = role;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ChatMessageBuilder() {
    ChatMessage._defaults(this);
  }

  ChatMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _role = $v.role;
      _content = $v.content;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessage other) {
    _$v = other as _$ChatMessage;
  }

  @override
  void update(void Function(ChatMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessage build() => _build();

  _$ChatMessage _build() {
    final _$result = _$v ??
        _$ChatMessage._(
          id: id,
          userId: userId,
          role: role,
          content: content,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
