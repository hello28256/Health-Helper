// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_chat_messages_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiChatMessagesPostRequest extends ApiChatMessagesPostRequest {
  @override
  final String content;

  factory _$ApiChatMessagesPostRequest(
          [void Function(ApiChatMessagesPostRequestBuilder)? updates]) =>
      (ApiChatMessagesPostRequestBuilder()..update(updates))._build();

  _$ApiChatMessagesPostRequest._({required this.content}) : super._();
  @override
  ApiChatMessagesPostRequest rebuild(
          void Function(ApiChatMessagesPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiChatMessagesPostRequestBuilder toBuilder() =>
      ApiChatMessagesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiChatMessagesPostRequest && content == other.content;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiChatMessagesPostRequest')
          ..add('content', content))
        .toString();
  }
}

class ApiChatMessagesPostRequestBuilder
    implements
        Builder<ApiChatMessagesPostRequest, ApiChatMessagesPostRequestBuilder> {
  _$ApiChatMessagesPostRequest? _$v;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  ApiChatMessagesPostRequestBuilder() {
    ApiChatMessagesPostRequest._defaults(this);
  }

  ApiChatMessagesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiChatMessagesPostRequest other) {
    _$v = other as _$ApiChatMessagesPostRequest;
  }

  @override
  void update(void Function(ApiChatMessagesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiChatMessagesPostRequest build() => _build();

  _$ApiChatMessagesPostRequest _build() {
    final _$result = _$v ??
        _$ApiChatMessagesPostRequest._(
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'ApiChatMessagesPostRequest', 'content'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
