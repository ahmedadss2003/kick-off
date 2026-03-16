import 'package:kickoff/features/stadiums/data/models/reply_model.dart';

class RepliesResponse {
  final bool success;
  final int code;
  final String message;
  final List<ReplyModel> data;

  RepliesResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory RepliesResponse.fromJson(Map<String, dynamic> json) {
    return RepliesResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ReplyModel.fromJson(e)).toList()
          : [],
    );
  }
}
