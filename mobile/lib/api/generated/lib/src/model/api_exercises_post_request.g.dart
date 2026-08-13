// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exercises_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiExercisesPostRequest extends ApiExercisesPostRequest {
  @override
  final String typeId;
  @override
  final DateTime startedAt;
  @override
  final int durationSec;
  @override
  final num? distanceKm;
  @override
  final String? clientId;

  factory _$ApiExercisesPostRequest(
          [void Function(ApiExercisesPostRequestBuilder)? updates]) =>
      (ApiExercisesPostRequestBuilder()..update(updates))._build();

  _$ApiExercisesPostRequest._(
      {required this.typeId,
      required this.startedAt,
      required this.durationSec,
      this.distanceKm,
      this.clientId})
      : super._();
  @override
  ApiExercisesPostRequest rebuild(
          void Function(ApiExercisesPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiExercisesPostRequestBuilder toBuilder() =>
      ApiExercisesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiExercisesPostRequest &&
        typeId == other.typeId &&
        startedAt == other.startedAt &&
        durationSec == other.durationSec &&
        distanceKm == other.distanceKm &&
        clientId == other.clientId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, typeId.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, durationSec.hashCode);
    _$hash = $jc(_$hash, distanceKm.hashCode);
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiExercisesPostRequest')
          ..add('typeId', typeId)
          ..add('startedAt', startedAt)
          ..add('durationSec', durationSec)
          ..add('distanceKm', distanceKm)
          ..add('clientId', clientId))
        .toString();
  }
}

class ApiExercisesPostRequestBuilder
    implements
        Builder<ApiExercisesPostRequest, ApiExercisesPostRequestBuilder> {
  _$ApiExercisesPostRequest? _$v;

  String? _typeId;
  String? get typeId => _$this._typeId;
  set typeId(String? typeId) => _$this._typeId = typeId;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  int? _durationSec;
  int? get durationSec => _$this._durationSec;
  set durationSec(int? durationSec) => _$this._durationSec = durationSec;

  num? _distanceKm;
  num? get distanceKm => _$this._distanceKm;
  set distanceKm(num? distanceKm) => _$this._distanceKm = distanceKm;

  String? _clientId;
  String? get clientId => _$this._clientId;
  set clientId(String? clientId) => _$this._clientId = clientId;

  ApiExercisesPostRequestBuilder() {
    ApiExercisesPostRequest._defaults(this);
  }

  ApiExercisesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _typeId = $v.typeId;
      _startedAt = $v.startedAt;
      _durationSec = $v.durationSec;
      _distanceKm = $v.distanceKm;
      _clientId = $v.clientId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiExercisesPostRequest other) {
    _$v = other as _$ApiExercisesPostRequest;
  }

  @override
  void update(void Function(ApiExercisesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiExercisesPostRequest build() => _build();

  _$ApiExercisesPostRequest _build() {
    final _$result = _$v ??
        _$ApiExercisesPostRequest._(
          typeId: BuiltValueNullFieldError.checkNotNull(
              typeId, r'ApiExercisesPostRequest', 'typeId'),
          startedAt: BuiltValueNullFieldError.checkNotNull(
              startedAt, r'ApiExercisesPostRequest', 'startedAt'),
          durationSec: BuiltValueNullFieldError.checkNotNull(
              durationSec, r'ApiExercisesPostRequest', 'durationSec'),
          distanceKm: distanceKm,
          clientId: clientId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
