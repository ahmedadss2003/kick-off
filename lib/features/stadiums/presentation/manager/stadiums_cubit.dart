import 'dart:developer';

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
      // Fetch stadiums from API
      final response = await stadiumRepository.getStadiums();
      List<StadiumModel> stadiums = response.data;

      // Optionally compute distance for each stadium
      final Position? position = await LocationService.getCurrentPosition();
      if (position != null) {
        stadiums = stadiums.map((stadium) {
          final lat = stadium.latitude;
          final lng = stadium.longitude;
          if (lat != null && lng != null) {
            final km = LocationService.distanceInKm(
              position.latitude,
              position.longitude,
              lat,
              lng,
            );
            return stadium.copyWith(distanceKm: km);
          }
          return stadium;
        }).toList();
      }

      emit(StadiumsSuccess(stadiums));
      log('[StadiumsCubit] Fetched ${stadiums.length} stadiums');
    } catch (e) {
      emit(StadiumsFailure(e.toString()));
      log('[StadiumsCubit] Error: $e');
    }
  }
}
