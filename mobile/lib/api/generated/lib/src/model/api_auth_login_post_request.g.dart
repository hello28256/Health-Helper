// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_login_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiAuthLoginPostRequest extends ApiAuthLoginPostRequest {
  @override
  final String email;
  @override
  final String password;
  @override
  final String deviceId;

  factory _$ApiAuthLoginPostRequest(
          [void Function(ApiAuthLoginPostRequestBuilder)? updates]) =>
      (ApiAuthLoginPostRequestBuilder()..update(updates))._build();

  _$ApiAuthLoginPostRequest._(
      {required this.email, required this.password, required this.deviceId})
      : super._();
  @override
  ApiAuthLoginPostRequest rebuild(
          void Function(ApiAuthLoginPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiAuthLoginPostRequestBuilder toBuilder() =>
      ApiAuthLoginPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiAuthLoginPostRequest &&
        email == other.email &&
        password == other.password &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiAuthLoginPostRequest')
          ..add('email', email)
          ..add('password', password)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class ApiAuthLoginPostRequestBuilder
    implements
        Builder<ApiAuthLoginPostRequest, ApiAuthLoginPostRequestBuilder> {
  _$ApiAuthLoginPostRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  ApiAuthLoginPostRequestBuilder() {
    ApiAuthLoginPostRequest._defaults(this);
  }

  ApiAuthLoginPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiAuthLoginPostRequest other) {
    _$v = other as _$ApiAuthLoginPostRequest;
  }

  @override
  void update(void Function(ApiAuthLoginPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiAuthLoginPostRequest build() => _build();

  _$ApiAuthLoginPostRequest _build() {
    final _$result = _$v ??
        _$ApiAuthLoginPostRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ApiAuthLoginPostRequest', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'ApiAuthLoginPostRequest', 'password'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'ApiAuthLoginPostRequest', 'deviceId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
