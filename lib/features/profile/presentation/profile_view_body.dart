import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';
import 'package:kickoff/features/profile/presentation/widgets/lang_section.dart';
import 'package:kickoff/features/profile/presentation/widgets/person_data_info.dart';
import 'package:kickoff/features/profile/presentation/widgets/support_section.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileSuccess) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    PersonalDataInfo(user: state.user),

                    const SizedBox(height: 16),

                    const LangSection(),

                    const SizedBox(height: 16),

                    const SupportAndLogoutSection(),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ProfileFailure) {
          return Center(child: Text(state.error));
        }

        return const SizedBox();
      },
    );
  }
}
