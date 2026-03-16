import 'package:kickoff/features/stadiums/data/models/review_model.dart';

class ReviewsResponse {
  final bool success;
  final int code;
  final String message;
  final List<ReviewModel> data;

  ReviewsResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
