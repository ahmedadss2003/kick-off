import 'package:kickoff/features/stadiums/data/models/review_model.dart';

class UpdateReviewResponse {
  final bool success;
  final int code;
  final String message;
  final ReviewModel? data;

  UpdateReviewResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory UpdateReviewResponse.fromJson(Map<String, dynamic> json) {
    return UpdateReviewResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReviewModel.fromJson(json['data']) : null,
    );
  }
}
