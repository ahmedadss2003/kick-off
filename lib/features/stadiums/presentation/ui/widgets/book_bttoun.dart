import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/booking_sheet.dart';

class BookButton extends StatelessWidget {
  final StadiumModel stadium;

  const BookButton({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: 300.ms, duration: 450.ms),
        SlideEffect(
          delay: 300.ms,
          duration: 450.ms,
          begin: const Offset(0, 0.5),
          end: Offset.zero,
          curve: Curves.easeOutBack,
        ),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BookingSheet(stadium: stadium),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8,
              shadowColor: AppColors.teal.withValues(alpha: 0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month_rounded, size: 22),
                SizedBox(width: 10),
                Text(
                  'احجز الآن',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
