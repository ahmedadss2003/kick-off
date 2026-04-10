import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/core/routes_manager/routes.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_state.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/market_image_app.dart';
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
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          title: const Text(
            'الملاعب المتاحة',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        body: BlocBuilder<StadiumsCubit, StadiumsState>(
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
                return const Center(
                  child: Text(
                    'لا توجد ملاعب متاحة حالياً',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }

              return _StadiumsSuccessBody(
                stadiums: state.stadiums,
                onRefresh: () => context.read<StadiumsCubit>().fetchStadiums(),
              );
            }

            return const SizedBox.shrink();
          },
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
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MarkingImageScreen(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'استكشف الملاعب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 252,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: stadiums.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  if (index == stadiums.length) {
                    return _ShowAllTile(onTap: () => _openAllStadiums(context));
                  }
                  return SizedBox(
                    width: 180,

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

class _ShowAllTile extends StatelessWidget {
  final VoidCallback onTap;

  const _ShowAllTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 104,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.grid_view_rounded,
                size: 36,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(height: 10),
              const Text(
                'عرض الكل',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),

              // Text(
              //   'Show all',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 10,
              //     color: Colors.grey.shade600,
              //     height: 1.1,
              //   ),
              // ),
              // const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

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
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
