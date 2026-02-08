import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/auth_screen/data/models/login_requsest.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/login/login_state.dart';
import 'package:kickoff/features/auth_screen/data/models/auth_models.dart';
import 'package:kickoff/features/auth_screen/data/repositories/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitial());

  Future<void> register(LoginRequest loginRequest) async {
    emit(LoginLoading());
    try {
      final user = await authRepository.login(loginRequest);
      emit(LoginSuccess(user));
      log('API Response: $user');
    } catch (e) {
      emit(LoginFailure(e.toString()));
      log(e.toString());
    }
  }

  Future<void> login(LoginRequest loginRequest) async {
    emit(LoginLoading());
    try {
      final user = await authRepository.login(loginRequest);
      emit(LoginSuccess(user));
      log('API Response: $user');
    } catch (e) {
      emit(LoginFailure(e.toString()));
      log(e.toString());
    }
  }
}
