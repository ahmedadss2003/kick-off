import 'dart:developer';

class RatingStatsModel {
  final double average;
  final int total;
  final List<int> distribution;
  final List<double> percentages;

  RatingStatsModel({
    required this.average,
    required this.total,
    required this.distribution,
    required this.percentages,
  });

  static Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw is Map<String, dynamic>) return raw;
    return json;
  }

  static double _readAverage(Map<String, dynamic> data) {
    final v = data['average'] ?? data['avg'] ?? data['average_rating'];
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static int _readTotal(Map<String, dynamic> data) {
    final v = data['total'] ?? data['total_ratings'] ?? data['count'];
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory RatingStatsModel.fromJson(Map<String, dynamic> json) {
    log('[RatingStatsModel] full json: $json');
    final data = _unwrapData(json);
    log('[RatingStatsModel] data: $data');
    return RatingStatsModel(
      average: _readAverage(data),
      total: _readTotal(data),
      distribution: List<int>.from(
        (data['distribution'] ?? []).map((e) => (e as num).toInt()),
      ),
      percentages: List<double>.from(
        (data['percentages'] ?? []).map((e) => (e as num).toDouble()),
      ),
    );
  }
}
