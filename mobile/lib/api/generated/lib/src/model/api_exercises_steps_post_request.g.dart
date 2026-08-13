// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exercises_steps_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiExercisesStepsPostRequestSource_Enum
    _$apiExercisesStepsPostRequestSourceEnum_iosPedometer =
    const ApiExercisesStepsPostRequestSource_Enum._('iosPedometer');
const ApiExercisesStepsPostRequestSource_Enum
    _$apiExercisesStepsPostRequestSourceEnum_androidSensor =
    const ApiExercisesStepsPostRequestSource_Enum._('androidSensor');
const ApiExercisesStepsPostRequestSource_Enum
    _$apiExercisesStepsPostRequestSourceEnum_manual =
    const ApiExercisesStepsPostRequestSource_Enum._('manual');

ApiExercisesStepsPostRequestSource_Enum
    _$apiExercisesStepsPostRequestSourceEnumValueOf(String name) {
  switch (name) {
    case 'iosPedometer':
      return _$apiExercisesStepsPostRequestSourceEnum_iosPedometer;
    case 'androidSensor':
      return _$apiExercisesStepsPostRequestSourceEnum_androidSensor;
    case 'manual':
      return _$apiExercisesStepsPostRequestSourceEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiExercisesStepsPostRequestSource_Enum>
    _$apiExercisesStepsPostRequestSourceEnumValues = BuiltSet<
        ApiExercisesStepsPostRequestSource_Enum>(const <ApiExercisesStepsPostRequestSource_Enum>[
  _$apiExercisesStepsPostRequestSourceEnum_iosPedometer,
  _$apiExercisesStepsPostRequestSourceEnum_androidSensor,
  _$apiExercisesStepsPostRequestSourceEnum_manual,
]);

Serializer<ApiExercisesStepsPostRequestSource_Enum>
    _$apiExercisesStepsPostRequestSourceEnumSerializer =
    _$ApiExercisesStepsPostRequestSource_EnumSerializer();

class _$ApiExercisesStepsPostRequestSource_EnumSerializer
    implements PrimitiveSerializer<ApiExercisesStepsPostRequestSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'iosPedometer': 'ios_pedometer',
    'androidSensor': 'android_sensor',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ios_pedometer': 'iosPedometer',
    'android_sensor': 'androidSensor',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiExercisesStepsPostRequestSource_Enum
  ];
  @override
  final String wireName = 'ApiExercisesStepsPostRequestSource_Enum';

  @override
  Object serialize(Serializers serializers,
          ApiExercisesStepsPostRequestSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiExercisesStepsPostRequestSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiExercisesStepsPostRequestSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiExercisesStepsPostRequest extends ApiExercisesStepsPostRequest {
  @override
  final DateTime? date;
  @override
  final int steps;
  @override
  final ApiExercisesStepsPostRequestSource_Enum? source_;

  factory _$ApiExercisesStepsPostRequest(
          [void Function(ApiExercisesStepsPostRequestBuilder)? updates]) =>
      (ApiExercisesStepsPostRequestBuilder()..update(updates))._build();

  _$ApiExercisesStepsPostRequest._(
      {this.date, required this.steps, this.source_})
      : super._();
  @override
  ApiExercisesStepsPostRequest rebuild(
          void Function(ApiExercisesStepsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiExercisesStepsPostRequestBuilder toBuilder() =>
      ApiExercisesStepsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiExercisesStepsPostRequest &&
        date == other.date &&
        steps == other.steps &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiExercisesStepsPostRequest')
          ..add('date', date)
          ..add('steps', steps)
          ..add('source_', source_))
        .toString();
  }
}

class ApiExercisesStepsPostRequestBuilder
    implements
        Builder<ApiExercisesStepsPostRequest,
            ApiExercisesStepsPostRequestBuilder> {
  _$ApiExercisesStepsPostRequest? _$v;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  int? _steps;
  int? get steps => _$this._steps;
  set steps(int? steps) => _$this._steps = steps;

  ApiExercisesStepsPostRequestSource_Enum? _source_;
  ApiExercisesStepsPostRequestSource_Enum? get source_ => _$this._source_;
  set source_(ApiExercisesStepsPostRequestSource_Enum? source_) =>
      _$this._source_ = source_;

  ApiExercisesStepsPostRequestBuilder() {
    ApiExercisesStepsPostRequest._defaults(this);
  }

  ApiExercisesStepsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _steps = $v.steps;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiExercisesStepsPostRequest other) {
    _$v = other as _$ApiExercisesStepsPostRequest;
  }

  @override
  void update(void Function(ApiExercisesStepsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiExercisesStepsPostRequest build() => _build();

  _$ApiExercisesStepsPostRequest _build() {
    final _$result = _$v ??
        _$ApiExercisesStepsPostRequest._(
          date: date,
          steps: BuiltValueNullFieldError.checkNotNull(
              steps, r'ApiExercisesStepsPostRequest', 'steps'),
          source_: source_,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
