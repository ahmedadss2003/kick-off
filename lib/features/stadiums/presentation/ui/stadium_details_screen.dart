import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/utils/custom_snackbar.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/book_bttoun.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_amenities_row.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_image_carousel.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_info_card.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_reviews_section.dart';

class StadiumDetailsScreen extends StatelessWidget {
  static const String routeName = '/stadium-details';

  final StadiumModel stadium;

  const StadiumDetailsScreen({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReviewsCubit(StadiumRepository(apiConsumer: DioConsumer(dio: Dio())))
            ..getReviews(stadium.id!),
      child: Scaffold(
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

                    // Reviews section
                    StadiumReviewsSection(stadiumId: stadium.id!),

                    const SizedBox(height: 100), // padding for bottom button
                  ],
                ),
              ),
            ),

            // ── احجز الآن button ─────────────────────────────────────────
            BookButton(stadium: stadium),
          ],
        ),
      ),
    );
  }
}
