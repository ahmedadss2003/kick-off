import '../models/user_profile_model.dart';
import '../services/profile_service.dart';

class ProfileRepo {
  final ProfileService service;

  ProfileRepo(this.service);

  Future<UserProfileModel> getProfile() async {
    final data = await service.getUserProfile();

    return UserProfileModel.fromJson(data['data']);
  }
}
