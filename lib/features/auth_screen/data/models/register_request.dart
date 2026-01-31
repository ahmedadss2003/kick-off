class RegisterRequest {
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String password;

  RegisterRequest({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'f_name': fname,
      'l_name': lname,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
  }
}
