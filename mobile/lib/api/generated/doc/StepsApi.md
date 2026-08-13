# health_helper_api.api.StepsApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiExercisesStepsPost**](StepsApi.md#apiexercisesstepspost) | **POST** /api/exercises/steps | 上报每日步数
[**apiExercisesStepsTodayGet**](StepsApi.md#apiexercisesstepstodayget) | **GET** /api/exercises/steps/today | 查询今日步数


# **apiExercisesStepsPost**
> DailyStep apiExercisesStepsPost(apiExercisesStepsPostRequest)

上报每日步数

同日多次上报采用 **max-value 策略**（避免移动端 OS 回退）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getStepsApi();
final ApiExercisesStepsPostRequest apiExercisesStepsPostRequest = ; // ApiExercisesStepsPostRequest | 

try {
    final response = api.apiExercisesStepsPost(apiExercisesStepsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StepsApi->apiExercisesStepsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiExercisesStepsPostRequest** | [**ApiExercisesStepsPostRequest**](ApiExercisesStepsPostRequest.md)|  | 

### Return type

[**DailyStep**](DailyStep.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiExercisesStepsTodayGet**
> DailyStep apiExercisesStepsTodayGet()

查询今日步数

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getStepsApi();

try {
    final response = api.apiExercisesStepsTodayGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling StepsApi->apiExercisesStepsTodayGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DailyStep**](DailyStep.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

