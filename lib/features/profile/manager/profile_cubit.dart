import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import '../data/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    try {
      final user = await repo.getProfile();

      emit(ProfileSuccess(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
