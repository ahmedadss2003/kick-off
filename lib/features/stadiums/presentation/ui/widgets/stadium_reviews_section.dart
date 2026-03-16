import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_state.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/review_card.dart';

class StadiumReviewsSection extends StatelessWidget {
  final int stadiumId;

  const StadiumReviewsSection({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التقييمات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddReviewDialog(context),
                icon: const Icon(Icons.add_comment, color: Color(0xFF2E7D32)),
                label: const Text(
                  'إضافة تقييم',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 12),

          BlocConsumer<ReviewsCubit, ReviewsState>(
            listener: (context, state) {
              if (state is AddReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت إضافة التقييم بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReviews(stadiumId);
              } else if (state is AddReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is UpdateReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث التقييم بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReviews(stadiumId);
              } else if (state is UpdateReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is DeleteReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف التقييم بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReviews(stadiumId);
              } else if (state is DeleteReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is AddReplySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت إضافة الرد بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReplies(state.reviewId);
              } else if (state is DeleteReplySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف الرد بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReplies(state.reviewId);
              } else if (state is UpdateReplySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تعديل الرد بنجاح'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.read<ReviewsCubit>().getReplies(state.reviewId);
              }
            },
            buildWhen: (previous, current) {
              return current is ReviewsLoading ||
                  current is ReviewsSuccess ||
                  current is ReviewsFailure ||
                  current is ReviewsInitial;
            },
            builder: (context, state) {
              if (state is ReviewsLoading || state is ReviewsInitial) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  ),
                );
              } else if (state is ReviewsFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'حدث خطأ في تحميل التقييمات',
                      style: TextStyle(color: Colors.red[300]),
                    ),
                  ),
                );
              } else if (state is ReviewsSuccess) {
                if (state.reviews.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'لا توجد تقييمات بعد. كن أول من يكتب تقييماً!',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms);
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.reviews.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return ReviewCard(
                      review: review,
                      index: index,
                      stadiumId: stadiumId,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext parentContext) {
    final controller = TextEditingController();
    final cubit = parentContext.read<ReviewsCubit>();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child:
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'إضافة تقييم',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'اكتب تقييمك هنا...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final content = controller.text.trim();
                        if (content.isNotEmpty) {
                          cubit.addReview(stadiumId, content);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'إرسال التقييم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(
                begin: 1,
                end: 0,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
        );
      },
    );
  }
}
