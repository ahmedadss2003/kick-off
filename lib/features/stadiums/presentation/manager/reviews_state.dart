import 'package:kickoff/features/stadiums/data/models/review_model.dart';
import 'package:kickoff/features/stadiums/data/models/reply_model.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsSuccess extends ReviewsState {
  final List<ReviewModel> reviews;
  ReviewsSuccess(this.reviews);
}

class ReviewsFailure extends ReviewsState {
  final String error;
  ReviewsFailure(this.error);
}

// Add Review States
class AddReviewLoading extends ReviewsState {}

class AddReviewSuccess extends ReviewsState {
  final ReviewModel review;
  AddReviewSuccess(this.review);
}

class AddReviewFailure extends ReviewsState {
  final String error;
  AddReviewFailure(this.error);
}

// Update Review States
class UpdateReviewLoading extends ReviewsState {}

class UpdateReviewSuccess extends ReviewsState {
  final ReviewModel review;
  UpdateReviewSuccess(this.review);
}

class UpdateReviewFailure extends ReviewsState {
  final String error;
  UpdateReviewFailure(this.error);
}

// Delete Review States
class DeleteReviewLoading extends ReviewsState {}

class DeleteReviewSuccess extends ReviewsState {}

class DeleteReviewFailure extends ReviewsState {
  final String error;
  DeleteReviewFailure(this.error);
}

// Get Replies States
class RepliesLoading extends ReviewsState {
  final int reviewId;
  RepliesLoading(this.reviewId);
}

class RepliesSuccess extends ReviewsState {
  final int reviewId;
  final List<ReplyModel> replies;
  RepliesSuccess(this.reviewId, this.replies);
}

class RepliesFailure extends ReviewsState {
  final int reviewId;
  final String error;
  RepliesFailure(this.reviewId, this.error);
}

// Add Reply States
class AddReplyLoading extends ReviewsState {}

class AddReplySuccess extends ReviewsState {
  final ReplyModel reply;
  final int reviewId;
  AddReplySuccess(this.reply, this.reviewId);
}

class AddReplyFailure extends ReviewsState {
  final String error;
  AddReplyFailure(this.error);
}

// Delete Reply States
class DeleteReplyLoading extends ReviewsState {}

class DeleteReplySuccess extends ReviewsState {
  final int reviewId;
  DeleteReplySuccess(this.reviewId);
}

class DeleteReplyFailure extends ReviewsState {
  final String error;
  DeleteReplyFailure(this.error);
}

// Update Reply States
class UpdateReplyLoading extends ReviewsState {}

class UpdateReplySuccess extends ReviewsState {
  final int reviewId;
  UpdateReplySuccess(this.reviewId);
}

class UpdateReplyFailure extends ReviewsState {
  final String error;
  UpdateReplyFailure(this.error);
}
