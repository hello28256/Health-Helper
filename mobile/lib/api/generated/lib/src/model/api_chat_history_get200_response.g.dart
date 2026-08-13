// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_chat_history_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiChatHistoryGet200Response extends ApiChatHistoryGet200Response {
  @override
  final BuiltList<ChatMessage>? history;

  factory _$ApiChatHistoryGet200Response(
          [void Function(ApiChatHistoryGet200ResponseBuilder)? updates]) =>
      (ApiChatHistoryGet200ResponseBuilder()..update(updates))._build();

  _$ApiChatHistoryGet200Response._({this.history}) : super._();
  @override
  ApiChatHistoryGet200Response rebuild(
          void Function(ApiChatHistoryGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiChatHistoryGet200ResponseBuilder toBuilder() =>
      ApiChatHistoryGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiChatHistoryGet200Response && history == other.history;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiChatHistoryGet200Response')
          ..add('history', history))
        .toString();
  }
}

class ApiChatHistoryGet200ResponseBuilder
    implements
        Builder<ApiChatHistoryGet200Response,
            ApiChatHistoryGet200ResponseBuilder> {
  _$ApiChatHistoryGet200Response? _$v;

  ListBuilder<ChatMessage>? _history;
  ListBuilder<ChatMessage> get history =>
      _$this._history ??= ListBuilder<ChatMessage>();
  set history(ListBuilder<ChatMessage>? history) => _$this._history = history;

  ApiChatHistoryGet200ResponseBuilder() {
    ApiChatHistoryGet200Response._defaults(this);
  }

  ApiChatHistoryGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _history = $v.history?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiChatHistoryGet200Response other) {
    _$v = other as _$ApiChatHistoryGet200Response;
  }

  @override
  void update(void Function(ApiChatHistoryGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiChatHistoryGet200Response build() => _build();

  _$ApiChatHistoryGet200Response _build() {
    _$ApiChatHistoryGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiChatHistoryGet200Response._(
            history: _history?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'history';
        _history?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiChatHistoryGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
