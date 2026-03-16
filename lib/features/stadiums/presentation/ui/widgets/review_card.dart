import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/end_points.dart';
import 'package:kickoff/core/databases/cache/cache_helper.dart';
import 'package:kickoff/features/profile/data/models/user_profile_model.dart';
import 'package:kickoff/features/stadiums/data/models/review_model.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/reviews_state.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/reply_card.dart';

class ReviewCard extends StatefulWidget {
  final ReviewModel review;
  final int index;
  final int stadiumId;

  const ReviewCard({
    required this.review,
    required this.index,
    required this.stadiumId,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _showReplies = false;

  @override
  Widget build(BuildContext context) {
    final userName = CacheHelper.getData<String>('userName');
    final userImage = CacheHelper.getData<String>('userImage');

    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userImage != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${EndPoints.imageBaseUrl}$userImage',
                          ),
                          backgroundColor: const Color(0xFFE8F5E9),
                        )
                      : CircleAvatar(
                          backgroundColor: const Color(0xFFE8F5E9),
                          child: Text(
                            widget.review.userId.toString(),
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'مستخدم ${widget.review.userId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.review.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black54),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditReviewDialog(context, widget.review);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, widget.review);
                      } else if (value == 'reply') {
                        _showAddReplyDialog(context, widget.review);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'reply',
                        child: Row(
                          children: [
                            Icon(Icons.reply, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text('رد'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('حذف', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Replies Section Toggle
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() {
                    _showReplies = !_showReplies;
                  });
                  if (_showReplies) {
                    context.read<ReviewsCubit>().getReplies(widget.review.id);
                  }
                },
                child: Text(
                  _showReplies ? 'إخفاء الردود ▲' : 'عرض الردود ▼',
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),

              // Replies List
              if (_showReplies)
                BlocBuilder<ReviewsCubit, ReviewsState>(
                  buildWhen: (previous, current) {
                    if (current is RepliesLoading &&
                        current.reviewId == widget.review.id)
                      return true;
                    if (current is RepliesSuccess &&
                        current.reviewId == widget.review.id)
                      return true;
                    if (current is RepliesFailure &&
                        current.reviewId == widget.review.id)
                      return true;
                    return false;
                  },
                  builder: (context, state) {
                    if (state is RepliesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (state is RepliesFailure) {
                      return Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (state is RepliesSuccess &&
                        state.reviewId == widget.review.id) {
                      if (state.replies.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('لا توجد ردود بعد.'),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.replies.length,
                        itemBuilder: (context, index) {
                          final reply = state.replies[index];
                          return ReplyCard(
                            reply: reply,
                            reviewId: widget.review.id,
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.index),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.1,
          delay: Duration(milliseconds: widget.index),
          duration: 400.ms,
        );
  }

  void _showEditReviewDialog(BuildContext parentContext, ReviewModel review) {
    final controller = TextEditingController(text: review.content);
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
                      'تعديل التقييم',
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
                        if (content.isNotEmpty && content != review.content) {
                          cubit.updateReview(review.id, content);
                          Navigator.of(context).pop();
                        } else if (content == review.content) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'تحديث التقييم',
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

  void _showAddReplyDialog(BuildContext parentContext, ReviewModel review) {
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
                      'إضافة رد',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'اكتب ردك هنا...',
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
                          cubit.addReply(review.id, content);
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
                        'إرسال الرد',
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

  void _showDeleteConfirmation(BuildContext parentContext, ReviewModel review) {
    final cubit = parentContext.read<ReviewsCubit>();

    showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من أنك تريد حذف هذا التقييم؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteReview(review.id);
                Navigator.of(context).pop();
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
