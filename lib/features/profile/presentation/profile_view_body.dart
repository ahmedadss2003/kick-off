import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';
import 'package:kickoff/features/profile/presentation/widgets/lang_section.dart';
import 'package:kickoff/features/profile/presentation/widgets/person_data_info.dart';
import 'package:kickoff/features/profile/presentation/widgets/support_section.dart';
import 'package:kickoff/features/profile/presentation/edit_profile_view.dart';
import 'package:kickoff/core/theming/colors.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) {
        // Only rebuild if it's a success, loading, or failure.
        // We handle dialogs in BlocListener if needed, but here we just want to avoid rebuilding on delete loading so UI doesn't vanish.
        return current is ProfileSuccess ||
            current is ProfileLoading ||
            current is ProfileFailure;
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileSuccess ||
            (context.read<ProfileCubit>().state is! ProfileLoading &&
                state is! ProfileFailure)) {
          // ensure we have user
          final user = state is ProfileSuccess
              ? state.user
              : null; // Fallback: wait for success.

          if (user == null) return const SizedBox();
          final userToDisplay = user;

          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => BlocProvider.value(
                        //           value: context.read<ProfileCubit>(),
                        //           child: EditProfileView(user: userToDisplay),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   icon: const Icon(Icons.edit_note, color: ColorsManager.mainColor, size: 28),
                        // ),
                      ],
                    ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0),

                    const SizedBox(height: 8),

                    PersonalDataInfo(user: userToDisplay)
                        .animate()
                        .fade(delay: 200.ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        ),

                    const SizedBox(height: 16),

                    const LangSection()
                        .animate()
                        .fade(delay: 400.ms)
                        .slideX(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    const SupportAndLogoutSection()
                        .animate()
                        .fade(delay: 500.ms)
                        .slideX(begin: -0.1, end: 0),

                    const SizedBox(height: 30),
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
