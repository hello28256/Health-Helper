// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_auth_refresh_post_request.g.dart';

/// ApiAuthRefreshPostRequest
///
/// Properties:
/// * [refreshToken] 
/// * [deviceId] 
@BuiltValue()
abstract class ApiAuthRefreshPostRequest implements Built<ApiAuthRefreshPostRequest, ApiAuthRefreshPostRequestBuilder> {
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  ApiAuthRefreshPostRequest._();

  factory ApiAuthRefreshPostRequest([void updates(ApiAuthRefreshPostRequestBuilder b)]) = _$ApiAuthRefreshPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiAuthRefreshPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiAuthRefreshPostRequest> get serializer => _$ApiAuthRefreshPostRequestSerializer();
}

class _$ApiAuthRefreshPostRequestSerializer implements PrimitiveSerializer<ApiAuthRefreshPostRequest> {
  @override
  final Iterable<Type> types = const [ApiAuthRefreshPostRequest, _$ApiAuthRefreshPostRequest];

  @override
  final String wireName = r'ApiAuthRefreshPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiAuthRefreshPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiAuthRefreshPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiAuthRefreshPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiAuthRefreshPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiAuthRefreshPostRequestBuilder();
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

