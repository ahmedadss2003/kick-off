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
    final rawImage = json['image'] as String? ?? '';
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      image: normalizeImageUrl(rawImage),
    );
  }

  /// Handles three formats the backend may return:
  ///   1. "public/storage/https://..."  → default external URL (strip bad prefix)
  ///   2. "public/storage/users/file"   → uploaded file (strip public/, prepend imageBaseUrl)
  ///   3. Already an "https://..." URL  → use as-is
  static String normalizeImageUrl(String raw) {
    if (raw.isEmpty) return raw;

    // Case 1: legacy default image wrapped in public/storage/https://
    if (raw.contains('public/storage/https://')) {
      return raw.replaceFirst('public/storage/', '');
    }

    // Case 2: relative path (e.g. public/storage/users/file.jpg)
    if (!raw.startsWith('http')) {
      // Strip the leading "public/" so we get "storage/users/file.jpg"
      final relative = raw.startsWith('public/')
          ? raw.substring('public/'.length)
          : raw;
      return '${EndPoints.imageBaseUrl}$relative';
    }

    // Case 3: already a full URL
    return raw;
  }
}
