import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/book_bttoun.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_amenities_row.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_image_carousel.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_info_card.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_rating_section.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_reviews_section.dart';

class StadiumDetailsScreen extends StatefulWidget {
  static const String routeName = '/stadium-details';

  final StadiumModel stadium;

  const StadiumDetailsScreen({super.key, required this.stadium});

  @override
  State<StadiumDetailsScreen> createState() => _StadiumDetailsScreenState();
}

class _StadiumDetailsScreenState extends State<StadiumDetailsScreen> {
  late StadiumModel _stadium;
  bool _loadingDetail = true;

  @override
  void initState() {
    super.initState();
    _stadium = widget.stadium;
    _loadFieldDetails();
  }

  Future<void> _loadFieldDetails() async {
    final id = widget.stadium.id;
    if (id == null) {
      setState(() => _loadingDetail = false);
      return;
    }

    try {
      final repo = StadiumRepository(apiConsumer: DioConsumer(dio: Dio()));
      final detail = await repo.getFieldDetails(id);
      if (!mounted) return;
      setState(() {
        _stadium = detail.copyWith(distanceKm: widget.stadium.distanceKm);
        _loadingDetail = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingDetail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل تفاصيل الملعب بالكامل')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = _stadium.id;
    if (id == null) {
      return const Scaffold(
        body: Center(child: Text('معرّف الملعب غير صالح')),
      );
    }

    return BlocProvider(
      create: (context) =>
          ReviewsCubit(StadiumRepository(apiConsumer: DioConsumer(dio: Dio())))
            ..getReviews(id),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            if (_loadingDetail)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFF2E7D32),
                backgroundColor: Color(0xFFE0E0E0),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StadiumImageCarousel(stadium: _stadium),
                    const SizedBox(height: 4),
                    StadiumInfoCard(stadium: _stadium)
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 350.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          delay: 100.ms,
                          duration: 350.ms,
                        ),
                    StadiumAmenitiesRow(stadium: _stadium)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 350.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          delay: 200.ms,
                          duration: 350.ms,
                        ),
                    const SizedBox(height: 20),
                    StadiumRatingSection(stadiumId: id),
                    const SizedBox(height: 8),
                    StadiumReviewsSection(stadiumId: id),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            BookButton(stadium: _stadium),
          ],
        ),
      ),
    );
  }
}
