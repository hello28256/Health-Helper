// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_users_me_patch_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiUsersMePatchRequest extends ApiUsersMePatchRequest {
  @override
  final String? displayName;
  @override
  final num? heightCm;
  @override
  final num? weightKg;
  @override
  final DateTime? birthDate;

  factory _$ApiUsersMePatchRequest(
          [void Function(ApiUsersMePatchRequestBuilder)? updates]) =>
      (ApiUsersMePatchRequestBuilder()..update(updates))._build();

  _$ApiUsersMePatchRequest._(
      {this.displayName, this.heightCm, this.weightKg, this.birthDate})
      : super._();
  @override
  ApiUsersMePatchRequest rebuild(
          void Function(ApiUsersMePatchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiUsersMePatchRequestBuilder toBuilder() =>
      ApiUsersMePatchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiUsersMePatchRequest &&
        displayName == other.displayName &&
        heightCm == other.heightCm &&
        weightKg == other.weightKg &&
        birthDate == other.birthDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, weightKg.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiUsersMePatchRequest')
          ..add('displayName', displayName)
          ..add('heightCm', heightCm)
          ..add('weightKg', weightKg)
          ..add('birthDate', birthDate))
        .toString();
  }
}

class ApiUsersMePatchRequestBuilder
    implements Builder<ApiUsersMePatchRequest, ApiUsersMePatchRequestBuilder> {
  _$ApiUsersMePatchRequest? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  num? _heightCm;
  num? get heightCm => _$this._heightCm;
  set heightCm(num? heightCm) => _$this._heightCm = heightCm;

  num? _weightKg;
  num? get weightKg => _$this._weightKg;
  set weightKg(num? weightKg) => _$this._weightKg = weightKg;

  DateTime? _birthDate;
  DateTime? get birthDate => _$this._birthDate;
  set birthDate(DateTime? birthDate) => _$this._birthDate = birthDate;

  ApiUsersMePatchRequestBuilder() {
    ApiUsersMePatchRequest._defaults(this);
  }

  ApiUsersMePatchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _heightCm = $v.heightCm;
      _weightKg = $v.weightKg;
      _birthDate = $v.birthDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiUsersMePatchRequest other) {
    _$v = other as _$ApiUsersMePatchRequest;
  }

  @override
  void update(void Function(ApiUsersMePatchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiUsersMePatchRequest build() => _build();

  _$ApiUsersMePatchRequest _build() {
    final _$result = _$v ??
        _$ApiUsersMePatchRequest._(
          displayName: displayName,
          heightCm: heightCm,
          weightKg: weightKg,
          birthDate: birthDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
