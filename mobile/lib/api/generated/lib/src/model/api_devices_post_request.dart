// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/device_platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_devices_post_request.g.dart';

/// ApiDevicesPostRequest
///
/// Properties:
/// * [deviceId] 
/// * [platform] 
/// * [fcmToken] - Android / Web 推送
/// * [apnsToken] - iOS 推送
/// * [appVersion] 
/// * [locale] 
@BuiltValue()
abstract class ApiDevicesPostRequest implements Built<ApiDevicesPostRequest, ApiDevicesPostRequestBuilder> {
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'platform')
  DevicePlatform get platform;
  // enum platformEnum {  ios,  android,  web,  };

  /// Android / Web 推送
  @BuiltValueField(wireName: r'fcmToken')
  String? get fcmToken;

  /// iOS 推送
  @BuiltValueField(wireName: r'apnsToken')
  String? get apnsToken;

  @BuiltValueField(wireName: r'appVersion')
  String? get appVersion;

  @BuiltValueField(wireName: r'locale')
  String? get locale;

  ApiDevicesPostRequest._();

  factory ApiDevicesPostRequest([void updates(ApiDevicesPostRequestBuilder b)]) = _$ApiDevicesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiDevicesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiDevicesPostRequest> get serializer => _$ApiDevicesPostRequestSerializer();
}

class _$ApiDevicesPostRequestSerializer implements PrimitiveSerializer<ApiDevicesPostRequest> {
  @override
  final Iterable<Type> types = const [ApiDevicesPostRequest, _$ApiDevicesPostRequest];

  @override
  final String wireName = r'ApiDevicesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiDevicesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(DevicePlatform),
    );
    if (object.fcmToken != null) {
      yield r'fcmToken';
      yield serializers.serialize(
        object.fcmToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.apnsToken != null) {
      yield r'apnsToken';
      yield serializers.serialize(
        object.apnsToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.appVersion != null) {
      yield r'appVersion';
      yield serializers.serialize(
        object.appVersion,
        specifiedType: const FullType(String),
      );
    }
    if (object.locale != null) {
      yield r'locale';
      yield serializers.serialize(
        object.locale,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiDevicesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiDevicesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DevicePlatform),
          ) as DevicePlatform;
          result.platform = valueDes;
          break;
        case r'fcmToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fcmToken = valueDes;
          break;
        case r'apnsToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apnsToken = valueDes;
          break;
        case r'appVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appVersion = valueDes;
          break;
        case r'locale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locale = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiDevicesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiDevicesPostRequestBuilder();
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

