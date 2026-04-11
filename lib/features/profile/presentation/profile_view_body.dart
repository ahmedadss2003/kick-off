import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/core/theming/colors.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';
import 'package:kickoff/features/profile/presentation/widgets/lang_section.dart';
import 'package:kickoff/features/profile/presentation/widgets/person_data_info.dart';
import 'package:kickoff/features/profile/presentation/widgets/support_section.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) {
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
          final user = state is ProfileSuccess ? state.user : null;

          if (user == null) return const SizedBox();
          final userToDisplay = user;

          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: Stack(
              children: [
                // Header Gradient
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.mainColor,
                        ColorsManager.mainColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      pinned: true,
                      title: const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // Main Profile Card
                            Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 30,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: PersonalDataInfo(user: userToDisplay),
                                )
                                .animate()
                                .fade(duration: 500.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 30),

                            // Settings Section Header
                            const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Account Settings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                )
                                .animate()
                                .fade(delay: 200.ms)
                                .slideX(begin: -0.1, end: 0),

                            const SizedBox(height: 16),

                            // Settings Group
                            Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      LangSection(),
                                      Divider(
                                        height: 1,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      SupportAndLogoutSection(),
                                    ],
                                  ),
                                )
                                .animate()
                                .fade(delay: 400.ms)
                                .slideY(begin: 0.1, end: 0),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
