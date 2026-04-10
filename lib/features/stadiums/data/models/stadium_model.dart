import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/features/stadiums/data/models/field_owner_model.dart';

class StadiumModel {
  final int? id;
  final String? name;
  final int? ownerId;
  final int? status;
  final String? description;
  final String? size;
  final num? price;
  final String? openingT;
  final String? closingT;
  final String? address;
  /// Maps URL (`https://...`) or legacy `"lat,lng"` string.
  final String? location;
  final num? rating;
  final String? phone;
  final FieldOwnerModel? owner;
  /// Relative path from API (e.g. `storage/fields/...`) or full URL.
  final String? coverImage;
  final List<String> images;

  /// Computed by the cubit after fetching user location
  final double? distanceKm;

  StadiumModel({
    this.id,
    this.name,
    this.ownerId,
    this.status,
    this.description,
    this.size,
    this.price,
    this.openingT,
    this.closingT,
    this.address,
    this.location,
    this.rating,
    this.phone,
    this.owner,
    this.coverImage,
    this.images = const [],
    this.distanceKm,
  });

  static String _absoluteImageUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http')) return trimmed;
    final base = EndPoints.imageBaseUrl.endsWith('/')
        ? EndPoints.imageBaseUrl
        : '${EndPoints.imageBaseUrl}/';
    final rel =
        trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '$base$rel';
  }

  factory StadiumModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>? ?? [];
    List<String> parsedImages = [];
    for (var imgObj in rawImages) {
      if (imgObj is Map<String, dynamic> && imgObj['image'] != null) {
        String url = imgObj['image'].toString();
        if (!url.startsWith('http')) {
          url = _absoluteImageUrl(url);
        }
        parsedImages.add(url);
      }
    }

    final coverRaw = json['cover_image']?.toString();
    final String? coverPath =
        (coverRaw != null && coverRaw.isNotEmpty) ? coverRaw : null;
    if (parsedImages.isEmpty && coverPath != null) {
      parsedImages = [_absoluteImageUrl(coverPath)];
    } else if (coverPath != null &&
        parsedImages.isNotEmpty &&
        !_listContainsPath(parsedImages, coverPath)) {
      parsedImages = [_absoluteImageUrl(coverPath), ...parsedImages];
    }

    FieldOwnerModel? owner;
    if (json['owner'] is Map<String, dynamic>) {
      owner = FieldOwnerModel.fromJson(json['owner'] as Map<String, dynamic>);
    }

    final topPhone = json['phone']?.toString();
    return StadiumModel(
      id: _readInt(json['id']),
      name: json['name']?.toString(),
      ownerId: _readInt(json['owner_id']) ?? owner?.id,
      status: _readInt(json['status']),
      description: json['description']?.toString(),
      size: json['size']?.toString(),
      price: json['price'] == null ? null : (json['price'] as num),
      openingT: json['opening_t']?.toString(),
      closingT: json['closing_t']?.toString(),
      address: json['address']?.toString(),
      location: json['location']?.toString(),
      rating: json['rating'] == null ? null : (json['rating'] as num),
      phone: (topPhone != null && topPhone.isNotEmpty) ? topPhone : owner?.phone,
      owner: owner,
      coverImage: coverPath,
      images: parsedImages,
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static bool _listContainsPath(List<String> urls, String rawPath) {
    final abs = _absoluteImageUrl(rawPath);
    return urls.any((u) => u == abs || u.endsWith(rawPath));
  }

  /// Returns a copy with [distanceKm] / [owner] overridden when provided.
  StadiumModel copyWith({double? distanceKm, FieldOwnerModel? owner}) {
    return StadiumModel(
      id: id,
      name: name,
      ownerId: ownerId,
      status: status,
      description: description,
      size: size,
      price: price,
      openingT: openingT,
      closingT: closingT,
      address: address,
      location: location,
      rating: rating,
      phone: phone,
      owner: owner ?? this.owner,
      coverImage: coverImage,
      images: images,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  bool get _locationIsLatLngPair {
    final l = location;
    if (l == null || l.isEmpty) return false;
    if (l.startsWith('http')) return false;
    return l.contains(',');
  }

  /// Parses latitude from legacy `"lat,lng"` (not used for map URLs).
  double? get latitude {
    if (!_locationIsLatLngPair) return null;
    final parts = location!.split(',');
    if (parts.length < 2) return null;
    return double.tryParse(parts[0].trim());
  }

  /// Parses longitude from legacy `"lat,lng"` (not used for map URLs).
  double? get longitude {
    if (!_locationIsLatLngPair) return null;
    final parts = location!.split(',');
    if (parts.length < 2) return null;
    return double.tryParse(parts[1].trim());
  }
}
