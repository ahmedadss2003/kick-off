import 'package:kickoff/core/databases/api/end_points.dart';

class UserProfileModel {
  final String name;
  final String email;
  final String mobileNumber;
  final String image;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Fix broken URL prefix from API: "public/storage/https://..."
    String rawImage = json['image'] ?? '';
    if (rawImage.contains('public/storage/https://')) {
      rawImage = rawImage.replaceFirst('public/storage/', '');
    } else if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      rawImage = '${EndPoints.baserUrl}storage/$rawImage';
    }

    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      image: rawImage,
    );
  }
}
