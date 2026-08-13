# health_helper_api.api.MoodApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiMoodGet**](MoodApi.md#apimoodget) | **GET** /api/mood | 查询情绪记录
[**apiMoodPost**](MoodApi.md#apimoodpost) | **POST** /api/mood | 记录一次情绪
[**apiMoodTrendGet**](MoodApi.md#apimoodtrendget) | **GET** /api/mood/trend | 查询情绪趋势（按日聚合）


# **apiMoodGet**
> ApiMoodGet200Response apiMoodGet(from, to)

查询情绪记录

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getMoodApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.apiMoodGet(from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MoodApi->apiMoodGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**ApiMoodGet200Response**](ApiMoodGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiMoodPost**
> MoodRecord apiMoodPost(apiMoodPostRequest)

记录一次情绪

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getMoodApi();
final ApiMoodPostRequest apiMoodPostRequest = ; // ApiMoodPostRequest | 

try {
    final response = api.apiMoodPost(apiMoodPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MoodApi->apiMoodPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiMoodPostRequest** | [**ApiMoodPostRequest**](ApiMoodPostRequest.md)|  | 

### Return type

[**MoodRecord**](MoodRecord.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiMoodTrendGet**
> ApiMoodTrendGet200Response apiMoodTrendGet(from, to)

查询情绪趋势（按日聚合）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getMoodApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.apiMoodTrendGet(from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MoodApi->apiMoodTrendGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | 
 **to** | **DateTime**|  | 

### Return type

[**ApiMoodTrendGet200Response**](ApiMoodTrendGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

