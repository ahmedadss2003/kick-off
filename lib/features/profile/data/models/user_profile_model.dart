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
    return UserProfileModel(
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      image: json['image'],
    );
  }
}
