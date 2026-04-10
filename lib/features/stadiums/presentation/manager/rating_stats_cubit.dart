import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/stadiums/data/models/rating_stats_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';

// States
abstract class RatingStatsState {}
class RatingStatsInitial extends RatingStatsState {}
class RatingStatsLoading extends RatingStatsState {}
class RatingStatsSuccess extends RatingStatsState {
  final RatingStatsModel stats;
  RatingStatsSuccess(this.stats);
}
class RatingStatsError extends RatingStatsState {
  final String error;
  RatingStatsError(this.error);
}

// Cubit
class RatingStatsCubit extends Cubit<RatingStatsState> {
  final StadiumRepository repository;

  RatingStatsCubit(this.repository) : super(RatingStatsInitial());

  Future<void> load(int fieldId) async {
    emit(RatingStatsLoading());
    try {
      final stats = await repository.getRatingStats(fieldId);
      emit(RatingStatsSuccess(stats));
    } catch (e) {
      log('Error getting rating stats: $e');
      emit(RatingStatsError(e.toString()));
    }
  }
}
