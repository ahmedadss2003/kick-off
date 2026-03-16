import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/core/utils/custom_snackbar.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/custom_btn.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

class BookButton extends StatelessWidget {
  final StadiumModel stadium;

  const BookButton({required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: 300.ms, duration: 350.ms),
        SlideEffect(
          delay: 300.ms,
          duration: 350.ms,
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),

        child: CustomBtn(
          text: 'احجز الآن',
          onPressed: () {
            showCustomSnackBar(
              context: context,
              message: 'جاري فتح الحجز لـ "${stadium.name}"',
              color: const Color(0xFF2E7D32),
            );
          },
        ),
      ),
    );
  }
}
