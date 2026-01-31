import 'package:kickoff/features/auth_screen/data/models/user_data.dart';

class UserModel {
  final bool? success;
  final String? message;
  final UserData? data;
  final String? token;

  UserModel({this.success, this.message, this.data, this.token});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Cannot create UserModel from null JSON');
    }

    return UserModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      token: json['token'],
    );
  }
}
