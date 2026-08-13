# health_helper_api.api.ChatApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiChatHistoryGet**](ChatApi.md#apichathistoryget) | **GET** /api/chat/history | 查询历史对话
[**apiChatMessagesPost**](ChatApi.md#apichatmessagespost) | **POST** /api/chat/messages | 发送 AI 对话


# **apiChatHistoryGet**
> ApiChatHistoryGet200Response apiChatHistoryGet(limit)

查询历史对话

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getChatApi();
final int limit = 56; // int | 

try {
    final response = api.apiChatHistoryGet(limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->apiChatHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**ApiChatHistoryGet200Response**](ApiChatHistoryGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiChatMessagesPost**
> ChatSendResult apiChatMessagesPost(apiChatMessagesPostRequest)

发送 AI 对话

AI 回复带 **医疗免责声明**（你不是医生 / 不能替代专业诊断）。服务端未配置 ANTHROPIC_API_KEY / OPENAI_API_KEY 时返回 503 AI_DISABLED；上游 AI 失败时返回 502 AI_UPSTREAM_ERROR。

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getChatApi();
final ApiChatMessagesPostRequest apiChatMessagesPostRequest = ; // ApiChatMessagesPostRequest | 

try {
    final response = api.apiChatMessagesPost(apiChatMessagesPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->apiChatMessagesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiChatMessagesPostRequest** | [**ApiChatMessagesPostRequest**](ApiChatMessagesPostRequest.md)|  | 

### Return type

[**ChatSendResult**](ChatSendResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

