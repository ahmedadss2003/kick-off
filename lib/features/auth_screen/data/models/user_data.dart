class UserData {
  final String name;
  final String email;

  UserData({required this.name, required this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(name: json['name'], email: json['email']);
  }
}
