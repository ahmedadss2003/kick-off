import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/features/stadiums/data/models/slots_model.dart';

// ─── States ──────────────────────────────────────────────────────────────────

abstract class SlotsState {}

class SlotsInitial extends SlotsState {}

class SlotsLoading extends SlotsState {}

class SlotsSuccess extends SlotsState {
  final SlotsResponse response;
  SlotsSuccess(this.response);
}

class SlotsFailure extends SlotsState {
  final String error;
  SlotsFailure(this.error);
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class SlotsCubit extends Cubit<SlotsState> {
  final DioConsumer api;

  SlotsCubit(this.api) : super(SlotsInitial());

  Future<void> loadSlots(int fieldId, String date) async {
    emit(SlotsLoading());
    try {
      final response = await api.get(EndPoints.getSlots(fieldId, date));

      if (response == null) throw Exception('No data returned');

      final json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      log('[SlotsCubit] response: $json');
      emit(SlotsSuccess(SlotsResponse.fromJson(json)));
    } catch (e) {
      log('[SlotsCubit] error: $e');
      emit(SlotsFailure(e.toString()));
    }
  }
}
