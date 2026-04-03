import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/features/stadiums/data/models/rating_stats_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/rating_stats_cubit.dart';

class StadiumRatingSection extends StatelessWidget {
  final int stadiumId;

  const StadiumRatingSection({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingStatsCubit(
        StadiumRepository(apiConsumer: DioConsumer(dio: Dio())),
      )..load(stadiumId),
      child: BlocBuilder<RatingStatsCubit, RatingStatsState>(
        builder: (context, state) {
          if (state is RatingStatsLoading || state is RatingStatsInitial) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32),
                  strokeWidth: 2,
                ),
              ),
            );
          }
          if (state is RatingStatsError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.black45),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تعذر تحميل إحصائيات التقييم',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<RatingStatsCubit>().load(stadiumId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is! RatingStatsSuccess) return const SizedBox.shrink();

          final RatingStatsModel stats = state.stats;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ──────────────────────────────────────────────────
                const Text(
                  'تقييمات العملاء',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Body: left score + right bars ──────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Left: big number / 5 + stars + total ───────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Big rating number with /5
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              stats.average.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                                height: 1,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text(
                                ' / 5',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Stars row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (i) {
                            final filled = i < stats.average.floor();
                            final half = !filled && i < stats.average;
                            return Icon(
                              half
                                  ? Icons.star_half
                                  : (filled ? Icons.star : Icons.star_border),
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),

                        const SizedBox(height: 6),

                        // Total ratings
                        Text(
                          '${stats.total} تقييم إجمالي',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(width: 20),

                    // ── Right: distribution bars (5 → 1) ───────────────────
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          // i=0 → star 5,  i=4 → star 1
                          final starIndex = 4 - i;
                          final pct = stats.percentages.length > starIndex
                              ? stats.percentages[starIndex]
                              : 0.0;
                          final count = stats.distribution.length > starIndex
                              ? stats.distribution[starIndex]
                              : 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                // "X نجوم" label
                                SizedBox(
                                  width: 56,
                                  child: Text(
                                    '${starIndex + 1} نجوم',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Progress bar
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct / 100,
                                      minHeight: 10,
                                      backgroundColor:
                                          const Color(0xFFE8E8E8),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFFC107), // amber – same as image
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // "XX% (N)" label
                                SizedBox(
                                  width: 58,
                                  child: Text(
                                    '${pct.toStringAsFixed(0)}% ($count)',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, duration: 400.ms);
        },
      ),
    );
  }
}
