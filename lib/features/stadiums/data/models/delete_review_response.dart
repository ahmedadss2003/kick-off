class DeleteReviewResponse {
  final bool success;
  final int code;
  final String message;

  DeleteReviewResponse({
    required this.success,
    required this.code,
    required this.message,
  });

  factory DeleteReviewResponse.fromJson(Map<String, dynamic> json) {
    return DeleteReviewResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
    );
  }
}
