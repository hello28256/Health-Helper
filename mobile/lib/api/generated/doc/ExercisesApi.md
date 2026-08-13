# health_helper_api.api.ExercisesApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiExercisesGet**](ExercisesApi.md#apiexercisesget) | **GET** /api/exercises | 查询运动记录
[**apiExercisesPost**](ExercisesApi.md#apiexercisespost) | **POST** /api/exercises | 创建运动记录
[**apiExercisesTypesGet**](ExercisesApi.md#apiexercisestypesget) | **GET** /api/exercises/types | 列出所有运动类型（含 MET + 注意事项）


# **apiExercisesGet**
> ApiExercisesGet200Response apiExercisesGet(from, to)

查询运动记录

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getExercisesApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.apiExercisesGet(from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ExercisesApi->apiExercisesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**ApiExercisesGet200Response**](ApiExercisesGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiExercisesPost**
> ExerciseRecord apiExercisesPost(apiExercisesPostRequest)

创建运动记录

calories 由服务端按 MET 公式权威计算（**不接受客户端传入 calories**）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getExercisesApi();
final ApiExercisesPostRequest apiExercisesPostRequest = ; // ApiExercisesPostRequest | 

try {
    final response = api.apiExercisesPost(apiExercisesPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ExercisesApi->apiExercisesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiExercisesPostRequest** | [**ApiExercisesPostRequest**](ApiExercisesPostRequest.md)|  | 

### Return type

[**ExerciseRecord**](ExerciseRecord.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiExercisesTypesGet**
> ApiExercisesTypesGet200Response apiExercisesTypesGet()

列出所有运动类型（含 MET + 注意事项）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getExercisesApi();

try {
    final response = api.apiExercisesTypesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ExercisesApi->apiExercisesTypesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiExercisesTypesGet200Response**](ApiExercisesTypesGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

