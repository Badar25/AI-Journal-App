class ErrorResponseBody {
  final String error;

  ErrorResponseBody({required this.error});

  factory ErrorResponseBody.fromJson(Map<String, dynamic> json) {
    return ErrorResponseBody(
      error: json['error'] as String,
    );
  }
}