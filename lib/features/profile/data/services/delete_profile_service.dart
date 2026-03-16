import 'package:dio/dio.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';

class DeleteProfileService {
  static final DioConsumer _dioConsumer = DioConsumer(dio: Dio());

  static Future<void> deleteProfile() async {
    await _dioConsumer.delete(EndPoints.deleteProfile);
  }
}
