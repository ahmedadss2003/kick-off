import 'dart:convert';

import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

class StadiumsResponse {
  final bool? success;
  final int? code;
  final String? message;
  final List<StadiumModel> data;

  StadiumsResponse({this.success, this.code, this.message, required this.data});

  factory StadiumsResponse.fromJson(Map<String, dynamic> json) {
    dynamic rawData = json['data'];
    List<dynamic> rawList = [];
    if (rawData is List<dynamic>) {
      rawList = rawData;
    } else if (rawData is String) {
      try {
        rawList = jsonDecode(rawData) as List<dynamic>? ?? [];
      } catch (_) {
        rawList = [];
      }
    }

    return StadiumsResponse(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => StadiumModel.fromJson(e))
          .toList(),
    );
  }
}
