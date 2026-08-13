// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceToken extends DeviceToken {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? deviceId;
  @override
  final DevicePlatform? platform;
  @override
  final String? fcmToken;
  @override
  final String? apnsToken;
  @override
  final String? appVersion;
  @override
  final String? locale;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastSeenAt;
  @override
  final DateTime? revokedAt;

  factory _$DeviceToken([void Function(DeviceTokenBuilder)? updates]) =>
      (DeviceTokenBuilder()..update(updates))._build();

  _$DeviceToken._(
      {this.id,
      this.userId,
      this.deviceId,
      this.platform,
      this.fcmToken,
      this.apnsToken,
      this.appVersion,
      this.locale,
      this.createdAt,
      this.lastSeenAt,
      this.revokedAt})
      : super._();
  @override
  DeviceToken rebuild(void Function(DeviceTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceTokenBuilder toBuilder() => DeviceTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceToken &&
        id == other.id &&
        userId == other.userId &&
        deviceId == other.deviceId &&
        platform == other.platform &&
        fcmToken == other.fcmToken &&
        apnsToken == other.apnsToken &&
        appVersion == other.appVersion &&
        locale == other.locale &&
        createdAt == other.createdAt &&
        lastSeenAt == other.lastSeenAt &&
        revokedAt == other.revokedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, fcmToken.hashCode);
    _$hash = $jc(_$hash, apnsToken.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, revokedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceToken')
          ..add('id', id)
          ..add('userId', userId)
          ..add('deviceId', deviceId)
          ..add('platform', platform)
          ..add('fcmToken', fcmToken)
          ..add('apnsToken', apnsToken)
          ..add('appVersion', appVersion)
          ..add('locale', locale)
          ..add('createdAt', createdAt)
          ..add('lastSeenAt', lastSeenAt)
          ..add('revokedAt', revokedAt))
        .toString();
  }
}

class DeviceTokenBuilder implements Builder<DeviceToken, DeviceTokenBuilder> {
  _$DeviceToken? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  DateTime? _revokedAt;
  DateTime? get revokedAt => _$this._revokedAt;
  set revokedAt(DateTime? revokedAt) => _$this._revokedAt = revokedAt;

  DeviceTokenBuilder() {
    DeviceToken._defaults(this);
  }

  DeviceTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _deviceId = $v.deviceId;
      _platform = $v.platform;
      _fcmToken = $v.fcmToken;
      _apnsToken = $v.apnsToken;
      _appVersion = $v.appVersion;
      _locale = $v.locale;
      _createdAt = $v.createdAt;
      _lastSeenAt = $v.lastSeenAt;
      _revokedAt = $v.revokedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceToken other) {
    _$v = other as _$DeviceToken;
  }

  @override
  void update(void Function(DeviceTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceToken build() => _build();

  _$DeviceToken _build() {
    final _$result = _$v ??
        _$DeviceToken._(
          id: id,
          userId: userId,
          deviceId: deviceId,
          platform: platform,
          fcmToken: fcmToken,
          apnsToken: apnsToken,
          appVersion: appVersion,
          locale: locale,
          createdAt: createdAt,
          lastSeenAt: lastSeenAt,
          revokedAt: revokedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
