import 'package:kickoff/features/stadiums/data/models/reply_model.dart';

class AddReplyResponse {
  final bool success;
  final int code;
  final String message;
  final ReplyModel? data;

  AddReplyResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory AddReplyResponse.fromJson(Map<String, dynamic> json) {
    return AddReplyResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 201,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReplyModel.fromJson(json['data']) : null,
    );
  }
}
