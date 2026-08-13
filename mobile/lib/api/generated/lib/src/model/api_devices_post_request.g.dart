// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_devices_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiDevicesPostRequest extends ApiDevicesPostRequest {
  @override
  final String deviceId;
  @override
  final DevicePlatform platform;
  @override
  final String? fcmToken;
  @override
  final String? apnsToken;
  @override
  final String? appVersion;
  @override
  final String? locale;

  factory _$ApiDevicesPostRequest(
          [void Function(ApiDevicesPostRequestBuilder)? updates]) =>
      (ApiDevicesPostRequestBuilder()..update(updates))._build();

  _$ApiDevicesPostRequest._(
      {required this.deviceId,
      required this.platform,
      this.fcmToken,
      this.apnsToken,
      this.appVersion,
      this.locale})
      : super._();
  @override
  ApiDevicesPostRequest rebuild(
          void Function(ApiDevicesPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiDevicesPostRequestBuilder toBuilder() =>
      ApiDevicesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiDevicesPostRequest &&
        deviceId == other.deviceId &&
        platform == other.platform &&
        fcmToken == other.fcmToken &&
        apnsToken == other.apnsToken &&
        appVersion == other.appVersion &&
        locale == other.locale;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, fcmToken.hashCode);
    _$hash = $jc(_$hash, apnsToken.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiDevicesPostRequest')
          ..add('deviceId', deviceId)
          ..add('platform', platform)
          ..add('fcmToken', fcmToken)
          ..add('apnsToken', apnsToken)
          ..add('appVersion', appVersion)
          ..add('locale', locale))
        .toString();
  }
}

class ApiDevicesPostRequestBuilder
    implements Builder<ApiDevicesPostRequest, ApiDevicesPostRequestBuilder> {
  _$ApiDevicesPostRequest? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  DevicePlatform? _platform;
  DevicePlatform? get platform => _$this._platform;
  set platform(DevicePlatform? platform) => _$this._platform = platform;

  String? _fcmToken;
  String? get fcmToken => _$this._fcmToken;
  set fcmToken(String? fcmToken) => _$this._fcmToken = fcmToken;

  String? _apnsToken;
  String? get apnsToken => _$this._apnsToken;
  set apnsToken(String? apnsToken) => _$this._apnsToken = apnsToken;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  ApiDevicesPostRequestBuilder() {
    ApiDevicesPostRequest._defaults(this);
  }

  ApiDevicesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _platform = $v.platform;
      _fcmToken = $v.fcmToken;
      _apnsToken = $v.apnsToken;
      _appVersion = $v.appVersion;
      _locale = $v.locale;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiDevicesPostRequest other) {
    _$v = other as _$ApiDevicesPostRequest;
  }

  @override
  void update(void Function(ApiDevicesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiDevicesPostRequest build() => _build();

  _$ApiDevicesPostRequest _build() {
    final _$result = _$v ??
        _$ApiDevicesPostRequest._(
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'ApiDevicesPostRequest', 'deviceId'),
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'ApiDevicesPostRequest', 'platform'),
          fcmToken: fcmToken,
          apnsToken: apnsToken,
          appVersion: appVersion,
          locale: locale,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
