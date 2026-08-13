// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_register_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiAuthRegisterPostRequest extends ApiAuthRegisterPostRequest {
  @override
  final String email;
  @override
  final String password;
  @override
  final String deviceId;
  @override
  final String? displayName;

  factory _$ApiAuthRegisterPostRequest(
          [void Function(ApiAuthRegisterPostRequestBuilder)? updates]) =>
      (ApiAuthRegisterPostRequestBuilder()..update(updates))._build();

  _$ApiAuthRegisterPostRequest._(
      {required this.email,
      required this.password,
      required this.deviceId,
      this.displayName})
      : super._();
  @override
  ApiAuthRegisterPostRequest rebuild(
          void Function(ApiAuthRegisterPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiAuthRegisterPostRequestBuilder toBuilder() =>
      ApiAuthRegisterPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiAuthRegisterPostRequest &&
        email == other.email &&
        password == other.password &&
        deviceId == other.deviceId &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiAuthRegisterPostRequest')
          ..add('email', email)
          ..add('password', password)
          ..add('deviceId', deviceId)
          ..add('displayName', displayName))
        .toString();
  }
}

class ApiAuthRegisterPostRequestBuilder
    implements
        Builder<ApiAuthRegisterPostRequest, ApiAuthRegisterPostRequestBuilder> {
  _$ApiAuthRegisterPostRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  ApiAuthRegisterPostRequestBuilder() {
    ApiAuthRegisterPostRequest._defaults(this);
  }

  ApiAuthRegisterPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _deviceId = $v.deviceId;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiAuthRegisterPostRequest other) {
    _$v = other as _$ApiAuthRegisterPostRequest;
  }

  @override
  void update(void Function(ApiAuthRegisterPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiAuthRegisterPostRequest build() => _build();

  _$ApiAuthRegisterPostRequest _build() {
    final _$result = _$v ??
        _$ApiAuthRegisterPostRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ApiAuthRegisterPostRequest', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'ApiAuthRegisterPostRequest', 'password'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'ApiAuthRegisterPostRequest', 'deviceId'),
          displayName: displayName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
