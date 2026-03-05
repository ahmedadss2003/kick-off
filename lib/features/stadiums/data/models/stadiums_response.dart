import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

class StadiumsResponse {
  final bool? success;
  final int? code;
  final String? message;
  final List<StadiumModel> data;

  StadiumsResponse({this.success, this.code, this.message, required this.data});

  factory StadiumsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    return StadiumsResponse(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: rawList
          .map((e) => StadiumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
