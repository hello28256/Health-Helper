// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthResult extends AuthResult {
  @override
  final PublicUser? user;
  @override
  final String? accessToken;
  @override
  final String? refreshToken;

  factory _$AuthResult([void Function(AuthResultBuilder)? updates]) =>
      (AuthResultBuilder()..update(updates))._build();

  _$AuthResult._({this.user, this.accessToken, this.refreshToken}) : super._();
  @override
  AuthResult rebuild(void Function(AuthResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthResultBuilder toBuilder() => AuthResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthResult &&
        user == other.user &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthResult')
          ..add('user', user)
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class AuthResultBuilder implements Builder<AuthResult, AuthResultBuilder> {
  _$AuthResult? _$v;

  PublicUserBuilder? _user;
  PublicUserBuilder get user => _$this._user ??= PublicUserBuilder();
  set user(PublicUserBuilder? user) => _$this._user = user;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  AuthResultBuilder() {
    AuthResult._defaults(this);
  }

  AuthResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user?.toBuilder();
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthResult other) {
    _$v = other as _$AuthResult;
  }

  @override
  void update(void Function(AuthResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthResult build() => _build();

  _$AuthResult _build() {
    _$AuthResult _$result;
    try {
      _$result = _$v ??
          _$AuthResult._(
            user: _user?.build(),
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AuthResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
