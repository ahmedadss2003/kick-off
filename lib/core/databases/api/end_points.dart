class EndPoints {
  static const String baserUrl = "https://kickoff.itravel2egypt.com/api/";
  static const String imageBaseUrl = "https://kickoff.itravel2egypt.com/";
  static const String register = "register";

  static const String login = "login";
  static const String logout = "logout";
  static const String stadiums = "user/fields";

  /// Single field (detail) — same resource as list item, full payload.
  static String getField(int id) => "user/fields/$id";

  /// Search fields — use GET with [queryParameters] e.g. `search` or `q`.
  static const String searchFields = "user/fields/search";
  static const String profile = "user/profile";
  static const String updateProfile = "user/profile/update";

  static const String deleteProfile = "user/profile/delete";

  static String reviews = "user/reviews/create";
  static String getReviews(int fieldId) => "user/reviews/field/$fieldId";
  static String updateReview(int reviewId) => "user/reviews/$reviewId";
  static String deleteReview(int reviewId) => "user/reviews/$reviewId";

  /// Rating distribution for a field (sibling route to [getReviews]).
  static String getRatingStats(int fieldId) => "user/reviews/$fieldId";

  static String addReply = "user/replies/create";
  static String getReplies(int reviewId) => "user/replies/$reviewId";
  static String updateReply(int replyId) => "user/replies/$replyId";
  static String deleteReply(int replyId) => "user/replies/$replyId";

  static String getSlots(int fieldId, String date) =>
      "fields/$fieldId/slots?date=$date";
}
