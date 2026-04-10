import 'package:kickoff/core/databases/api/end_points.dart';

/// Owner block from `user/fields/{id}` detail response.
class FieldOwnerModel {
  final int? id;
  final String? email;
  final String? name;
  final String? imageUrl;
  final String? phone;

  FieldOwnerModel({
    this.id,
    this.email,
    this.name,
    this.imageUrl,
    this.phone,
  });

  factory FieldOwnerModel.fromJson(Map<String, dynamic> json) {
    final raw = json['image']?.toString();
    String? imageUrl;
    if (raw != null && raw.isNotEmpty) {
      imageUrl = raw.startsWith('http') ? raw : _absoluteImageUrl(raw);
    }
    return FieldOwnerModel(
      id: _readInt(json['id']),
      email: json['email']?.toString(),
      name: json['name']?.toString(),
      imageUrl: imageUrl,
      phone: json['phone']?.toString(),
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String _absoluteImageUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http')) return trimmed;
    final base = EndPoints.imageBaseUrl.endsWith('/')
        ? EndPoints.imageBaseUrl
        : '${EndPoints.imageBaseUrl}/';
    final rel = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '$base$rel';
  }
}
