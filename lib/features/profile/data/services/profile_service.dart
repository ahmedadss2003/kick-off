import 'package:dio/dio.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/utils/app_session.dart';

class ProfileService {
  final Dio dio;

  ProfileService(this.dio);

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await dio.get(
      "${EndPoints.baserUrl}${EndPoints.profile}",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppSession.token}",
          "Accept": "application/json",
        },
      ),
    );
    print(response.data);
    return response.data;
  }
}
