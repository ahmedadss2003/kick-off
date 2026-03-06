import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/features/stadiums/data/repositories/stadium_repository.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/stadiums_state.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_card.dart';

/// The main stadiums list screen.
/// Shows a 2-column grid of [StadiumCard]s matching the home screen mockup.
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
            // ── Loading ─────────────────────────────────────────────
            if (state is StadiumsLoading || state is StadiumsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              );
            }

            // ── Error ───────────────────────────────────────────────
            if (state is StadiumsFailure) {
              return _ErrorView(
                message: state.error,
                onRetry: () => context.read<StadiumsCubit>().fetchStadiums(),
              );
            }

            // ── Success ─────────────────────────────────────────────
            if (state is StadiumsSuccess) {
              if (state.stadiums.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد ملاعب متاحة حالياً',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF2E7D32),
                onRefresh: () => context.read<StadiumsCubit>().fetchStadiums(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: state.stadiums.length,
                  itemBuilder: (context, index) {
                    return StadiumCard(
                      stadium: state.stadiums[index],
                      index: index,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Private error view widget ──────────────────────────────────────────────

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
