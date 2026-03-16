part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileModel user;

  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);
}

// Update Profile
class ProfileUpdateLoading extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {}
class ProfileUpdateFailure extends ProfileState {
  final String error;
  ProfileUpdateFailure(this.error);
}

// Delete Profile
class ProfileDeleteLoading extends ProfileState {}
class ProfileDeleteSuccess extends ProfileState {}
class ProfileDeleteFailure extends ProfileState {
  final String error;
  ProfileDeleteFailure(this.error);
}
