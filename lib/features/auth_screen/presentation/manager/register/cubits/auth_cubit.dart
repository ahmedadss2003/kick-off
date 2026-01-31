import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/auth_screen/data/models/register_request.dart';
import 'package:kickoff/features/auth_screen/presentation/manager/register/cubits/auth_states.dart';
import 'package:kickoff/features/auth_screen/data/models/auth_models.dart';
import 'package:kickoff/features/auth_screen/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> register(RegisterRequest registerRequest) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(registerRequest);
      emit(AuthSuccess(user));
      log('API Response: $user');
    } catch (e) {
      emit(AuthFailure(e.toString()));
      log(e.toString());
    }
  }
}
