import 'package:dio/dio.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/utils/app_session.dart';

class LogoutService {
  final Dio dio;

  LogoutService(this.dio);

  Future<void> logout() async {
    await dio.post(
      "${EndPoints.baserUrl}${EndPoints.logout}",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppSession.token}",
          "Accept": "application/json",
        },
      ),
    );
    AppSession.token = null;
  }
}
