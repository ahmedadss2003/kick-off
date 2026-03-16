import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import 'package:kickoff/features/profile/data/services/update_profile.dart';
import 'package:kickoff/features/profile/data/services/delete_profile_service.dart';
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

  Future<void> updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      var response = await UpdateProfileService.updateProfileData(
        name: name,
        email: email,
        mobileNumber: phone,
      );
      emit(ProfileUpdateSuccess());
      // Refresh profile data after update
      if (response != null && response['data'] != null) {
        final updatedUser = UserProfileModel.fromJson(response['data']);
        emit(ProfileSuccess(updatedUser));
      } else {
        await getProfile();
      }
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }

  void updateProfileImageLocally(String newImageUrl) {
    if (state is ProfileSuccess) {
      final currentUser = (state as ProfileSuccess).user;
      final updatedUser = UserProfileModel(
        name: currentUser.name,
        email: currentUser.email,
        mobileNumber: currentUser.mobileNumber,
        image: newImageUrl,
      );
      emit(ProfileSuccess(updatedUser));
    }
  }

  Future<void> deleteUserAccount() async {
    emit(ProfileDeleteLoading());
    try {
      await DeleteProfileService.deleteProfile();
      emit(ProfileDeleteSuccess());
    } catch (e) {
      emit(ProfileDeleteFailure(e.toString()));
    }
  }
}
