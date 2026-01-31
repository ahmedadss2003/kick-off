import 'dart:developer';

import 'package:kickoff/core/databases/api/api_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/features/auth_screen/data/models/auth_models.dart';
import 'package:kickoff/features/auth_screen/data/models/login_requsest.dart';
import 'package:kickoff/features/auth_screen/data/models/register_request.dart';

class AuthRepository {
  final ApiConsumer apiConsumer;

  AuthRepository({required this.apiConsumer});

  Future<UserModel> register(RegisterRequest registerRequest) async {
    log('Sending request to: ${EndPoints.register}');
    log('Request data: ${registerRequest.toJson()}');

    final response = await apiConsumer.post(
      'https://kickoff.itravel2egypt.com/api/register',
      data: registerRequest.toJson(),
    );

    log('API Response Type: ${response.runtimeType}');
    log('API Response: $response');

    if (response == null) {
      throw Exception('Registration failed: Server returned no data');
    }

    return UserModel.fromJson(response);
  }

  Future<UserModel> login(LoginRequest loginRequest) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      data: loginRequest.toJson(),
    );
    return UserModel.fromJson(response);
  }
}
