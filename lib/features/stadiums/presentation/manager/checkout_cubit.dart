import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/features/stadiums/data/models/checkout_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';

// ─── States ──────────────────────────────────────────────────────────────────

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final CheckoutResponse response;
  CheckoutSuccess(this.response);
}

class CheckoutFailure extends CheckoutState {
  final String error;
  CheckoutFailure(this.error);
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class CheckoutCubit extends Cubit<CheckoutState> {
  final StadiumRepository _repository;

  CheckoutCubit()
      : _repository = StadiumRepository(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
        super(CheckoutInitial());

  Future<void> checkout(CheckoutRequest request) async {
    emit(CheckoutLoading());
    try {
      log('[CheckoutCubit] Sending checkout: ${request.toJson()}');
      final response = await _repository.checkout(request);
      emit(CheckoutSuccess(response));
    } catch (e) {
      log('[CheckoutCubit] Error: $e');
      emit(CheckoutFailure(e.toString()));
    }
  }
}
