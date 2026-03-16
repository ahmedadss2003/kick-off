import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://kickoff.itravel2egypt.com/api/user/revies/1');
    print(jsonEncode(response.data));
  } catch (e) {
    if (e is DioException) {
      print('DioError: \${e.response?.statusCode} - \${e.response?.data}');
    } else {
      print('Error: $e');
    }
  }
}
