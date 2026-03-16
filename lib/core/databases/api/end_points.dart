class EndPoints {
  static const String baserUrl = "https://kickoff.itravel2egypt.com/api/";
  static const String imageBaseUrl = "https://kickoff.itravel2egypt.com/";
  static const String register = "register";

  static const String login = "login";
  static const String logout = "logout";
  static const String stadiums = "user/fields";
  static const String profile = "user/profile";

  static String reviews = "user/revies/create";
  static String getReviews(int fieldId) => "user/revies/$fieldId";
  static String updateReview(int reviewId) => "user/revies/$reviewId";
  static String deleteReview(int reviewId) => "user/revies/$reviewId";

  static String addReply = "user/replies/create";
  static String getReplies(int reviewId) => "user/replies/$reviewId";
  static String updateReply(int replyId) => "user/replies/$replyId";
  static String deleteReply(int replyId) => "user/replies/$replyId";
}
