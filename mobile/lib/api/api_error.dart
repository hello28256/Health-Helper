// ApiError —— 后端约定的错误结构
//
// 后端响应错误时：
//   { "error": { "code": "VALIDATION_ERROR", "message": "...", "details": {...} } }
//
// 这个文件把后端错误码映射成 Dart 异常类型 + 提供 isXxx 判断，
// 让 UI 层 / Provider 层可以语义化处理（401/403/404/500）。

class ApiError implements Exception {
  ApiError({
    required this.code,
    required this.message,
    this.status,
    this.details,
  });

  /// 后端错误码，如 UNAUTHORIZED / VALIDATION_ERROR / NOT_FOUND / ...
  final String code;

  final String message;

  /// HTTP 状态码（如 401/404），没有的话为 null（如 dio 解析失败）
  final int? status;

  final Object? details;

  bool get isUnauthorized => code == 'UNAUTHORIZED' || status == 401;
  bool get isForbidden => code == 'FORBIDDEN' || status == 403;
  bool get isNotFound => code == 'NOT_FOUND' || status == 404;
  bool get isValidation => code == 'VALIDATION_ERROR' || status == 400;
  bool get isServer => status != null && status! >= 500;
  bool get isAiDisabled => code == 'AI_DISABLED';
  bool get isAiUpstream => code == 'AI_UPSTREAM_ERROR';

  @override
  String toString() => 'ApiError($code, $status): $message';
}
