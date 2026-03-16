import 'package:kickoff/features/stadiums/data/models/review_model.dart';

class AddReviewResponse {
  final bool success;
  final int code;
  final String message;
  final ReviewModel? data;

  AddReviewResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) {
    return AddReviewResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 201,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReviewModel.fromJson(json['data']) : null,
    );
  }
}
