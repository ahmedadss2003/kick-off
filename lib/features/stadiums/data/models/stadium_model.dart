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
  final String? location; // "lat,lng" format
  final num? rating;
  final String? phone;
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
    this.images = const [],
    this.distanceKm,
  });

  factory StadiumModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>? ?? [];
    return StadiumModel(
      id: json['id'],
      name: json['name'],
      ownerId: json['owner_id'],
      status: json['status'],
      description: json['description'],
      size: json['size'],
      price: json['price'],
      openingT: json['opening_t'],
      closingT: json['closing_t'],
      address: json['address'],
      location: json['location'],
      rating: json['rating'],
      phone: json['phone'],
      images: rawImages.map((e) => e.toString()).toList(),
    );
  }

  /// Returns a copy with [distanceKm] set
  StadiumModel copyWith({double? distanceKm}) {
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
      images: images,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  /// Parses latitude from "lat,lng" location string
  double? get latitude {
    if (location == null) return null;
    final parts = location!.split(',');
    if (parts.length < 2) return null;
    return double.tryParse(parts[0].trim());
  }

  /// Parses longitude from "lat,lng" location string
  double? get longitude {
    if (location == null) return null;
    final parts = location!.split(',');
    if (parts.length < 2) return null;
    return double.tryParse(parts[1].trim());
  }
}
