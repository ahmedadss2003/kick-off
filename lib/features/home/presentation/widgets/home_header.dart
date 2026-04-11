import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/profile/manager/profile_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String userName = 'Guest';
        String userImage = '';

        if (state is ProfileSuccess) {
          userName = state.user.name ?? 'User';
          userImage = state.user.image ?? '';
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً بيك، $userName 👋',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'جاهز للعب؟ ⚽',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.teal.withValues(alpha: 0.1),
                  backgroundImage: userImage.isNotEmpty
                      ? NetworkImage(userImage)
                      : null,
                  child: userImage.isEmpty
                      ? const Icon(Icons.person, color: AppColors.teal, size: 30)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
