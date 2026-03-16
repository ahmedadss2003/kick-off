class ReviewModel {
  final int id;
  final String content;
  final String? imageUrl;
  final int userId;
  final dynamic fieldId;

  ReviewModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.userId,
    required this.fieldId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? json['image'], // Handle both get and add responses
      userId: json['user_id'],
      fieldId: json['field_id'],
    );
  }
}
