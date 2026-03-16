import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final StadiumRepository stadiumRepository;

  ReviewsCubit(this.stadiumRepository) : super(ReviewsInitial());

  Future<void> getReviews(int fieldId) async {
    emit(ReviewsLoading());
    try {
      final response = await stadiumRepository.getReviews(fieldId);
      emit(ReviewsSuccess(response.data));
    } catch (e) {
      log('Error getting reviews: $e');
      emit(ReviewsFailure(e.toString()));
    }
  }

  Future<void> addReview(int fieldId, String content) async {
    emit(AddReviewLoading());
    try {
      final response = await stadiumRepository.addReview(fieldId, content);

      if (response.success && response.data != null) {
        emit(AddReviewSuccess(response.data!));
      } else {
        emit(AddReviewFailure(response.message));
      }
    } catch (e) {
      log('Error adding review: $e');
      emit(AddReviewFailure(e.toString()));
    }
  }

  Future<void> updateReview(int reviewId, String content) async {
    emit(UpdateReviewLoading());
    try {
      final response = await stadiumRepository.updateReview(reviewId, content);

      if (response.success && response.data != null) {
        emit(UpdateReviewSuccess(response.data!));
      } else {
        emit(UpdateReviewFailure(response.message));
      }
    } catch (e) {
      log('Error updating review: $e');
      emit(UpdateReviewFailure(e.toString()));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    emit(DeleteReviewLoading());
    try {
      final response = await stadiumRepository.deleteReview(reviewId);

      if (response.success) {
        emit(DeleteReviewSuccess());
      } else {
        emit(DeleteReviewFailure(response.message));
      }
    } catch (e) {
      log('Error deleting review: $e');
      emit(DeleteReviewFailure(e.toString()));
    }
  }

  Future<void> getReplies(int reviewId) async {
    emit(RepliesLoading(reviewId));
    try {
      final response = await stadiumRepository.getReplies(reviewId);
      emit(RepliesSuccess(reviewId, response.data));
    } catch (e) {
      log('Error getting replies: $e');
      emit(RepliesFailure(reviewId, e.toString()));
    }
  }

  Future<void> addReply(int reviewId, String content) async {
    emit(AddReplyLoading());
    try {
      final response = await stadiumRepository.addReply(reviewId, content);

      if (response.success && response.data != null) {
        emit(AddReplySuccess(response.data!, reviewId));
      } else {
        emit(AddReplyFailure(response.message));
      }
    } catch (e) {
      log('Error adding reply: $e');
      emit(AddReplyFailure(e.toString()));
    }
  }

  Future<void> deleteReply(int replyId, int reviewId) async {
    emit(DeleteReplyLoading());
    try {
      final response = await stadiumRepository.deleteReply(replyId);

      if (response.success) {
        emit(DeleteReplySuccess(reviewId));
      } else {
        emit(DeleteReplyFailure(response.message));
      }
    } catch (e) {
      log('Error deleting reply: $e');
      emit(DeleteReplyFailure(e.toString()));
    }
  }

  Future<void> updateReply(int replyId, int reviewId, String content) async {
    emit(UpdateReplyLoading());
    try {
      final response = await stadiumRepository.updateReply(replyId, reviewId, content);

      if (response.success) {
        emit(UpdateReplySuccess(reviewId));
      } else {
        emit(UpdateReplyFailure(response.message));
      }
    } catch (e) {
      log('Error updating reply: $e');
      emit(UpdateReplyFailure(e.toString()));
    }
  }
}
