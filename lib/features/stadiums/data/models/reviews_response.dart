import 'dart:developer';
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
    List<ReviewModel> reviews = [];

    final rawData = json['data'];
    log('[ReviewsResponse] raw data type: ${rawData.runtimeType}');
    log('[ReviewsResponse] raw data: $rawData');

    if (rawData is List) {
      // data is directly a list of reviews
      reviews = rawData
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      // data might be a paginated object with a 'data' key inside
      final inner = rawData['data'];
      if (inner is List) {
        reviews = inner
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return ReviewsResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: reviews,
    );
  }
}
