import 'dart:developer';

import 'package:kickoff/core/databases/api/api_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/features/stadiums/data/models/stadiums_response.dart';

class StadiumRepository {
  final ApiConsumer apiConsumer;

  StadiumRepository({required this.apiConsumer});

  Future<StadiumsResponse> getStadiums() async {
    log('Fetching stadiums from: ${EndPoints.stadiums}');
    final response = await apiConsumer.get(EndPoints.stadiums);

    log('Stadiums response: $response');

    if (response == null) {
      throw Exception('Failed to fetch stadiums: Server returned no data');
    }

    return StadiumsResponse.fromJson(response as Map<String, dynamic>);
  }
}
