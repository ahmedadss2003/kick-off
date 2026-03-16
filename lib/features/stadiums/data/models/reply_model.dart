class ReplyModel {
  final int id;
  final String content;
  final String? image;
  final int userId;
  final dynamic reviewId;

  ReplyModel({
    required this.id,
    required this.content,
    this.image,
    required this.userId,
    required this.reviewId,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'],
      content: json['content'] ?? '',
      image: json['image'],
      userId: json['user_id'],
      reviewId: json['revie_id'],
    );
  }
}
