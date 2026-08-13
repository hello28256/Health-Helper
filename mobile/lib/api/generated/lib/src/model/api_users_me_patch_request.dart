// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_users_me_patch_request.g.dart';

/// ApiUsersMePatchRequest
///
/// Properties:
/// * [displayName] 
/// * [heightCm] 
/// * [weightKg] 
/// * [birthDate] 
@BuiltValue()
abstract class ApiUsersMePatchRequest implements Built<ApiUsersMePatchRequest, ApiUsersMePatchRequestBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'heightCm')
  num? get heightCm;

  @BuiltValueField(wireName: r'weightKg')
  num? get weightKg;

  @BuiltValueField(wireName: r'birthDate')
  DateTime? get birthDate;

  ApiUsersMePatchRequest._();

  factory ApiUsersMePatchRequest([void updates(ApiUsersMePatchRequestBuilder b)]) = _$ApiUsersMePatchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiUsersMePatchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiUsersMePatchRequest> get serializer => _$ApiUsersMePatchRequestSerializer();
}

class _$ApiUsersMePatchRequestSerializer implements PrimitiveSerializer<ApiUsersMePatchRequest> {
  @override
  final Iterable<Type> types = const [ApiUsersMePatchRequest, _$ApiUsersMePatchRequest];

  @override
  final String wireName = r'ApiUsersMePatchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiUsersMePatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.heightCm != null) {
      yield r'heightCm';
      yield serializers.serialize(
        object.heightCm,
        specifiedType: const FullType(num),
      );
    }
    if (object.weightKg != null) {
      yield r'weightKg';
      yield serializers.serialize(
        object.weightKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.birthDate != null) {
      yield r'birthDate';
      yield serializers.serialize(
        object.birthDate,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiUsersMePatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiUsersMePatchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'heightCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.heightCm = valueDes;
          break;
        case r'weightKg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.weightKg = valueDes;
          break;
        case r'birthDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.birthDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiUsersMePatchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiUsersMePatchRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

