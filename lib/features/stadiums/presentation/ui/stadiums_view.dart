import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/routes_manager/routes.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_state.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/market_image_app.dart';
import 'package:kickoff/features/home/presentation/widgets/home_header.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_card.dart';

/// Home stadiums: horizontal row; "عرض الكل" opens [AllStadiumsScreen] (2 columns).
class StadiumsView extends StatelessWidget {
  static const String routeName = '/stadiums';

  const StadiumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StadiumsCubit(StadiumRepository(apiConsumer: DioConsumer(dio: Dio())))
            ..fetchStadiums(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: BlocBuilder<StadiumsCubit, StadiumsState>(
            builder: (context, state) {
              if (state is StadiumsLoading || state is StadiumsInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                );
              }

              if (state is StadiumsFailure) {
                return _ErrorView(
                  message: state.error,
                  onRetry: () => context.read<StadiumsCubit>().fetchStadiums(),
                );
              }

              if (state is StadiumsSuccess) {
                if (state.stadiums.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد ملاعب متاحة حالياً',
                      style: TextStyle(color: Colors.black54, fontSize: 16.sp),
                    ),
                  );
                }

                return _StadiumsSuccessBody(
                  stadiums: state.stadiums,
                  onRefresh: () =>
                      context.read<StadiumsCubit>().fetchStadiums(),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _StadiumsSuccessBody extends StatelessWidget {
  final List<StadiumModel> stadiums;
  final Future<void> Function() onRefresh;

  const _StadiumsSuccessBody({required this.stadiums, required this.onRefresh});

  void _openAllStadiums(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.stadiumsAll, arguments: stadiums);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF2E7D32),
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            const MarkingImageScreen(),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _openAllStadiums(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'استكشف الملاعب',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: stadiums.length + 1,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  if (index == stadiums.length) {
                    return SizedBox();
                  }
                  return SizedBox(
                    width: 180.w,

                    child: StadiumCard(stadium: stadiums[index], index: index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _ShowAllTile extends StatelessWidget {
//   final VoidCallback onTap;

//   const _ShowAllTile({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       margin: const EdgeInsets.only(right: 8, left: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: AppColors.teal.withValues(alpha: 0.1),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFE0F2F1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.grid_view_rounded,
//                   size: 28,
//                   color: AppColors.teal,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 'عرض الكل',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.black26, size: 60),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ أثناء التحميل',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.black38, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text('إعادة المحاولة', style: TextStyle(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
