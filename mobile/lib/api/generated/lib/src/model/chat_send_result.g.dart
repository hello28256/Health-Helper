// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_send_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSendResult extends ChatSendResult {
  @override
  final ChatMessage? userMessage;
  @override
  final ChatMessage? assistantMessage;

  factory _$ChatSendResult([void Function(ChatSendResultBuilder)? updates]) =>
      (ChatSendResultBuilder()..update(updates))._build();

  _$ChatSendResult._({this.userMessage, this.assistantMessage}) : super._();
  @override
  ChatSendResult rebuild(void Function(ChatSendResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSendResultBuilder toBuilder() => ChatSendResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSendResult &&
        userMessage == other.userMessage &&
        assistantMessage == other.assistantMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userMessage.hashCode);
    _$hash = $jc(_$hash, assistantMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatSendResult')
          ..add('userMessage', userMessage)
          ..add('assistantMessage', assistantMessage))
        .toString();
  }
}

class ChatSendResultBuilder
    implements Builder<ChatSendResult, ChatSendResultBuilder> {
  _$ChatSendResult? _$v;

  ChatMessageBuilder? _userMessage;
  ChatMessageBuilder get userMessage =>
      _$this._userMessage ??= ChatMessageBuilder();
  set userMessage(ChatMessageBuilder? userMessage) =>
      _$this._userMessage = userMessage;

  ChatMessageBuilder? _assistantMessage;
  ChatMessageBuilder get assistantMessage =>
      _$this._assistantMessage ??= ChatMessageBuilder();
  set assistantMessage(ChatMessageBuilder? assistantMessage) =>
      _$this._assistantMessage = assistantMessage;

  ChatSendResultBuilder() {
    ChatSendResult._defaults(this);
  }

  ChatSendResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userMessage = $v.userMessage?.toBuilder();
      _assistantMessage = $v.assistantMessage?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatSendResult other) {
    _$v = other as _$ChatSendResult;
  }

  @override
  void update(void Function(ChatSendResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSendResult build() => _build();

  _$ChatSendResult _build() {
    _$ChatSendResult _$result;
    try {
      _$result = _$v ??
          _$ChatSendResult._(
            userMessage: _userMessage?.build(),
            assistantMessage: _assistantMessage?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'userMessage';
        _userMessage?.build();
        _$failedField = 'assistantMessage';
        _assistantMessage?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatSendResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
