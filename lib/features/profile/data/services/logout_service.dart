import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/databases/cache/cache_helper.dart';
import 'package:kickoff/core/utils/app_session.dart';

class LogoutService {
  final DioConsumer dioConsumer;

  LogoutService({required this.dioConsumer});

  Future<void> logout() async {
    try {
      await dioConsumer.post(EndPoints.logout);
      AppSession.token = null;
      await CacheHelper.removeData('userToken');
      await CacheHelper.removeData('userName');
      await CacheHelper.removeData('userImage');
    } catch (e) {
      print(e);
    }
  }
}
