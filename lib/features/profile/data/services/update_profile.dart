import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/utils/app_session.dart';

class UpdateProfileService {
  static final DioConsumer _dioConsumer = DioConsumer(dio: Dio());

  static Future<String> updateProfileImage({
    required File imageFile,
    required String name,
    required String email,
    required String mobileNumber,
  }) async {
    final response = await _dioConsumer.patch(
      EndPoints.updateProfile,
      data: {
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
      },
      isFormData: true,
    );

    final newImageUrl = response['data']['image'] as String? ?? '';
    await AppSession.saveProfileImage(newImageUrl);

    return newImageUrl;
  }

  static Future<dynamic> updateProfileData({
    required String name,
    required String email,
    required String mobileNumber,
  }) async {
    final response = await _dioConsumer.post(
      EndPoints.updateProfile,
      data: {
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
        '_method': 'PATCH',
      },
      isFormData: true,
    );

    return response;
  }
}
