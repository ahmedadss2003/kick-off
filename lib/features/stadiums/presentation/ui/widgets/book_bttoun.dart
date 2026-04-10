import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/booking_sheet.dart';

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
        child: SizedBox(
          width: double.infinity,
          height: 54,
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
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 20),
                SizedBox(width: 8),
                Text(
                  'احجز الآن',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
