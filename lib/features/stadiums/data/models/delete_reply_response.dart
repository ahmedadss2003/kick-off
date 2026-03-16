class DeleteReplyResponse {
  final bool success;
  final int code;
  final String message;

  DeleteReplyResponse({
    required this.success,
    required this.code,
    required this.message,
  });

  factory DeleteReplyResponse.fromJson(Map<String, dynamic> json) {
    return DeleteReplyResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
    );
  }
}
