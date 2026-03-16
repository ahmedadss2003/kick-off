import 'dart:convert';
import 'dart:developer';

import 'package:kickoff/core/databases/api/api_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/features/stadiums/data/models/stadiums_response.dart';
import 'package:kickoff/features/stadiums/data/models/reviews_response.dart';
import 'package:kickoff/features/stadiums/data/models/add_review_response.dart';
import 'package:kickoff/features/stadiums/data/models/update_review_response.dart';
import 'package:kickoff/features/stadiums/data/models/delete_review_response.dart';
import 'package:kickoff/features/stadiums/data/models/replies_response.dart';
import 'package:kickoff/features/stadiums/data/models/add_reply_response.dart';
import 'package:kickoff/features/stadiums/data/models/delete_reply_response.dart';

class StadiumRepository {
  final ApiConsumer apiConsumer;

  StadiumRepository({required this.apiConsumer});

  Future<StadiumsResponse> getStadiums() async {
    log('Fetching stadiums from: ${EndPoints.stadiums}');
    final response = await apiConsumer.get(EndPoints.stadiums);

    log('Stadiums response: $response');

    if (response == null) {
      throw Exception('Failed to fetch stadiums: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return StadiumsResponse.fromJson(json);
  }

  Future<ReviewsResponse> getReviews(int fieldId) async {
    log('Fetching reviews from: ${EndPoints.getReviews(fieldId)}');
    final response = await apiConsumer.get(EndPoints.getReviews(fieldId));

    if (response == null) {
      throw Exception('Failed to fetch reviews: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return ReviewsResponse.fromJson(json);
  }

  Future<AddReviewResponse> addReview(int fieldId, String content) async {
    log('Adding review to: ${EndPoints.reviews}');
    final response = await apiConsumer.post(
      EndPoints.reviews,
      data: {'fields_id': fieldId, 'content': content},
    );

    if (response == null) {
      throw Exception('Failed to add review: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return AddReviewResponse.fromJson(json);
  }

  Future<UpdateReviewResponse> updateReview(int reviewId, String content) async {
    log('Updating review: ${EndPoints.updateReview(reviewId)}');
    final response = await apiConsumer.patch(
      EndPoints.updateReview(reviewId),
      data: {'content': content},
    );

    if (response == null) {
      throw Exception('Failed to update review: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return UpdateReviewResponse.fromJson(json);
  }

  Future<DeleteReviewResponse> deleteReview(int reviewId) async {
    log('Deleting review: ${EndPoints.deleteReview(reviewId)}');
    final response = await apiConsumer.delete(
      EndPoints.deleteReview(reviewId),
    );

    if (response == null) {
      throw Exception('Failed to delete review: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return DeleteReviewResponse.fromJson(json);
  }

  Future<RepliesResponse> getReplies(int reviewId) async {
    log('Fetching replies from: ${EndPoints.getReplies(reviewId)}');
    final response = await apiConsumer.get(EndPoints.getReplies(reviewId));

    if (response == null) {
      throw Exception('Failed to fetch replies: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return RepliesResponse.fromJson(json);
  }

  Future<AddReplyResponse> addReply(int reviewId, String content) async {
    log('Adding reply to: ${EndPoints.addReply}');
    final response = await apiConsumer.post(
      EndPoints.addReply,
      data: {'revie_id': reviewId, 'content': content},
    );

    if (response == null) {
      throw Exception('Failed to add reply: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return AddReplyResponse.fromJson(json);
  }

  Future<DeleteReplyResponse> deleteReply(int replyId) async {
    log('Deleting reply: ${EndPoints.deleteReply(replyId)}');
    final response = await apiConsumer.delete(
      EndPoints.deleteReply(replyId),
    );

    if (response == null) {
      throw Exception('Failed to delete reply: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return DeleteReplyResponse.fromJson(json);
  }

  Future<AddReplyResponse> updateReply(int replyId, int reviewId, String content) async {
    log('Updating reply: ${EndPoints.updateReply(replyId)}');
    final response = await apiConsumer.patch(
      EndPoints.updateReply(replyId),
      data: {'content': content},
    );

    if (response == null) {
      throw Exception('Failed to update reply: Server returned no data');
    }

    final Map<String, dynamic> json = response is String
        ? (jsonDecode(response) as Map<String, dynamic>)
        : response as Map<String, dynamic>;

    return AddReplyResponse.fromJson(json);
  }
}
