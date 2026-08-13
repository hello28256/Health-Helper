// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_health_records_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiHealthRecordsPostRequest extends ApiHealthRecordsPostRequest {
  @override
  final BuiltList<ApiHealthRecordsPostRequestRecordsInner> records;

  factory _$ApiHealthRecordsPostRequest(
          [void Function(ApiHealthRecordsPostRequestBuilder)? updates]) =>
      (ApiHealthRecordsPostRequestBuilder()..update(updates))._build();

  _$ApiHealthRecordsPostRequest._({required this.records}) : super._();
  @override
  ApiHealthRecordsPostRequest rebuild(
          void Function(ApiHealthRecordsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiHealthRecordsPostRequestBuilder toBuilder() =>
      ApiHealthRecordsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiHealthRecordsPostRequest && records == other.records;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiHealthRecordsPostRequest')
          ..add('records', records))
        .toString();
  }
}

class ApiHealthRecordsPostRequestBuilder
    implements
        Builder<ApiHealthRecordsPostRequest,
            ApiHealthRecordsPostRequestBuilder> {
  _$ApiHealthRecordsPostRequest? _$v;

  ListBuilder<ApiHealthRecordsPostRequestRecordsInner>? _records;
  ListBuilder<ApiHealthRecordsPostRequestRecordsInner> get records =>
      _$this._records ??=
          ListBuilder<ApiHealthRecordsPostRequestRecordsInner>();
  set records(ListBuilder<ApiHealthRecordsPostRequestRecordsInner>? records) =>
      _$this._records = records;

  ApiHealthRecordsPostRequestBuilder() {
    ApiHealthRecordsPostRequest._defaults(this);
  }

  ApiHealthRecordsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiHealthRecordsPostRequest other) {
    _$v = other as _$ApiHealthRecordsPostRequest;
  }

  @override
  void update(void Function(ApiHealthRecordsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiHealthRecordsPostRequest build() => _build();

  _$ApiHealthRecordsPostRequest _build() {
    _$ApiHealthRecordsPostRequest _$result;
    try {
      _$result = _$v ??
          _$ApiHealthRecordsPostRequest._(
            records: records.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        records.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiHealthRecordsPostRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
