class UserData {
  final String? name;
  final String? email;
  final String? image;

  UserData({this.name, this.email, this.image});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      image: json['image'], // Added image
    );
  }
}
