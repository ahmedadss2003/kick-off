import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

class FieldDetailsResponse {
  final bool success;
  final int code;
  final String message;
  final StadiumModel data;

  FieldDetailsResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FieldDetailsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw is! Map<String, dynamic>) {
      throw FormatException('Field details: missing data object');
    }
    return FieldDetailsResponse(
      success: json['success'] == true,
      code: _readInt(json['code']) ?? 0,
      message: json['message']?.toString() ?? '',
      data: StadiumModel.fromJson(raw),
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
