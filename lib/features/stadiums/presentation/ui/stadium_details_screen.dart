import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_amenities_row.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_image_carousel.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_info_card.dart';

/// Full details screen for a single stadium.
/// Matches the right-side UI mockup:
///   - Image carousel at top
///   - Name + rating info card
///   - Action buttons (location, phone, size)
///   - Amenities row
///   - "احجز الآن" bottom button
class StadiumDetailsScreen extends StatelessWidget {
  static const String routeName = '/stadium-details';

  final StadiumModel stadium;

  const StadiumDetailsScreen({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: true,

      // ── Transparent AppBar overlaying the image ──────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ── Scrollable body ──────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image carousel (full width, no padding)
                  StadiumImageCarousel(stadium: stadium),

                  const SizedBox(height: 4),

                  // Info card + action buttons
                  StadiumInfoCard(stadium: stadium)
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 350.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        delay: 100.ms,
                        duration: 350.ms,
                      ),

                  // Amenities row
                  StadiumAmenitiesRow(stadium: stadium)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 350.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        delay: 200.ms,
                        duration: 350.ms,
                      ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── احجز الآن button ─────────────────────────────────────────
          _BookButton(stadium: stadium),
        ],
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final StadiumModel stadium;

  const _BookButton({required this.stadium});

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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                // TODO: navigate to booking screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري فتح الحجز لـ "${stadium.name}"'),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'احجز الآن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
