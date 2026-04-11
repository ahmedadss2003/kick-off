import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/profile/data/repos/profile_repo.dart';
import 'package:kickoff/features/profile/data/services/profile_service.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';
import 'package:kickoff/features/profile/presentation/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileViewBody();
  }
}
