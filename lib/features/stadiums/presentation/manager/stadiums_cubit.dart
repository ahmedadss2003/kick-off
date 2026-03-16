import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kickoff/core/utils/location_service.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_state.dart';

class StadiumsCubit extends Cubit<StadiumsState> {
  final StadiumRepository stadiumRepository;

  StadiumsCubit(this.stadiumRepository) : super(StadiumsInitial());

  Future<void> fetchStadiums() async {
    emit(StadiumsLoading());
    try {
      final response = await stadiumRepository.getStadiums();
      List<StadiumModel> stadiums = response.data;

      final Position? position = await LocationService.getCurrentPosition();

      if (position != null) {
        // resolve all URLs in parallel
        final resolved = await Future.wait(
          stadiums.map((stadium) => _resolveCoords(stadium)),
        );

        stadiums = List.generate(stadiums.length, (i) {
          final coords = resolved[i];
          if (coords != null) {
            final km = LocationService.distanceInKm(
              position.latitude,
              position.longitude,
              coords.$1, // lat
              coords.$2, // lng
            );
            return stadiums[i].copyWith(distanceKm: km);
          }
          return stadiums[i];
        });
      }

      emit(StadiumsSuccess(stadiums));
      log('[StadiumsCubit] Fetched ${stadiums.length} stadiums');
    } catch (e) {
      emit(StadiumsFailure(e.toString()));
      log('[StadiumsCubit] Error: $e');
    }
  }

  /// Returns (lat, lng) from any location format
  Future<(double, double)?> _resolveCoords(StadiumModel stadium) async {
    final location = stadium.location;
    if (location == null) return null;

    // Case 1: plain "lat,lng"
    if (!location.startsWith('http')) {
      final lat = stadium.latitude;
      final lng = stadium.longitude;
      if (lat != null && lng != null) return (lat, lng);
      return null;
    }

    // Case 2: resolve short URL → extract coords from final URL
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(location));
      final response = await request.close();
      final finalUrl = response.headers.value(HttpHeaders.locationHeader) ?? '';
      client.close();

      log('[StadiumsCubit] Resolved URL: $finalUrl');

      // Extract from "@lat,lng" pattern in the full Google Maps URL
      final match = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)').firstMatch(finalUrl);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null) return (lat, lng);
      }

      // Extract from "query=lat,lng"
      final uri = Uri.tryParse(finalUrl);
      final query = uri?.queryParameters['query'];
      if (query != null) {
        final parts = query.split(',');
        if (parts.length >= 2) {
          final lat = double.tryParse(parts[0].trim());
          final lng = double.tryParse(parts[1].trim());
          if (lat != null && lng != null) return (lat, lng);
        }
      }
    } catch (e) {
      log('[StadiumsCubit] Failed to resolve URL: $e');
    }

    return null;
  }
}
