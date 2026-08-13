// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_refresh_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiAuthRefreshPostRequest extends ApiAuthRefreshPostRequest {
  @override
  final String refreshToken;
  @override
  final String deviceId;

  factory _$ApiAuthRefreshPostRequest(
          [void Function(ApiAuthRefreshPostRequestBuilder)? updates]) =>
      (ApiAuthRefreshPostRequestBuilder()..update(updates))._build();

  _$ApiAuthRefreshPostRequest._(
      {required this.refreshToken, required this.deviceId})
      : super._();
  @override
  ApiAuthRefreshPostRequest rebuild(
          void Function(ApiAuthRefreshPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiAuthRefreshPostRequestBuilder toBuilder() =>
      ApiAuthRefreshPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiAuthRefreshPostRequest &&
        refreshToken == other.refreshToken &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiAuthRefreshPostRequest')
          ..add('refreshToken', refreshToken)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class ApiAuthRefreshPostRequestBuilder
    implements
        Builder<ApiAuthRefreshPostRequest, ApiAuthRefreshPostRequestBuilder> {
  _$ApiAuthRefreshPostRequest? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  ApiAuthRefreshPostRequestBuilder() {
    ApiAuthRefreshPostRequest._defaults(this);
  }

  ApiAuthRefreshPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiAuthRefreshPostRequest other) {
    _$v = other as _$ApiAuthRefreshPostRequest;
  }

  @override
  void update(void Function(ApiAuthRefreshPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiAuthRefreshPostRequest build() => _build();

  _$ApiAuthRefreshPostRequest _build() {
    final _$result = _$v ??
        _$ApiAuthRefreshPostRequest._(
          refreshToken: BuiltValueNullFieldError.checkNotNull(
              refreshToken, r'ApiAuthRefreshPostRequest', 'refreshToken'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'ApiAuthRefreshPostRequest', 'deviceId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
