import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/core/routes_manager/routes.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_image_area.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_info_row.dart';

class StadiumCard extends StatelessWidget {
  final StadiumModel stadium;
  final int index;

  const StadiumCard({super.key, required this.stadium, required this.index});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: 80 * index),
          duration: const Duration(milliseconds: 400),
        ),
        SlideEffect(
          delay: Duration(milliseconds: 80 * index),
          duration: const Duration(milliseconds: 400),
          begin: const Offset(0, 0.15),
          end: Offset.zero,
          curve: Curves.easeOut,
        ),
      ],
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
        ).pushNamed(Routes.stadiumDetails, arguments: stadium),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.teal.withValues(alpha: 0.03),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Image with rating badge ─────────────────────────────
              StadiumImageArea(stadium: stadium),

              // ─── Name + price + distance ─────────────────────────────
              StadiumInfoRow(stadium: stadium),
            ],
          ),
        ),
      ),
    );
  }
}
