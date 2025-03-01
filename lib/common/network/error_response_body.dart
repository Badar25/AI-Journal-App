
class APIResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final String? error;

  APIResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'],
      error: json['error'] as String?,
    );
  }
}
