import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/utils/app_session.dart';

class UpdateProfileService {
  static final Dio _dio = Dio();

  static Future<String> updateProfileImage(File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await _dio.patch(
      '${EndPoints.baserUrl}${EndPoints.updateProfile}',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AppSession.token}',
          'Accept': 'application/json',
        },
      ),
    );

    final newImageUrl = response.data['data']['image'] as String? ?? '';
    await AppSession.saveProfileImage(newImageUrl);

    return newImageUrl;
  }
}
