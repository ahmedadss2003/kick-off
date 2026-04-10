class UserModel {
  final int id;
  final String name;
  final String email;
  final String? image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
    );
  }
}

class ReviewModel {
  final int id;
  final String content;
  final int rating;
  final String? imageUrl;
  final int? userId;
  final dynamic fieldId;
  final UserModel? user;
  final String? createdAt;

  ReviewModel({
    required this.id,
    required this.content,
    this.rating = 0,
    this.imageUrl,
    this.userId,
    required this.fieldId,
    this.user,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      content: json['comment'] ?? json['content'] ?? '',
      rating: json['rating'] ?? 0,
      imageUrl: json['image_url'] ?? json['image'],
      userId: json['user_id'] ?? (json['user'] != null ? json['user']['id'] : null),
      fieldId: json['field_id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'] ?? json['date'],
    );
  }
}
