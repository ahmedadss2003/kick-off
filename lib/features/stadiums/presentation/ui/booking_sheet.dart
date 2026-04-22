import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kickoff/core/databases/api/dio_consumer.dart';
import 'package:kickoff/features/stadiums/data/models/checkout_model.dart';
import 'package:kickoff/features/stadiums/data/models/slots_model.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/manager/booking_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/checkout_cubit.dart';
import 'package:kickoff/features/stadiums/presentation/manager/slots_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingSheet extends StatefulWidget {
  final StadiumModel stadium;

  const BookingSheet({super.key, required this.stadium});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  DateTime _selectedDate = DateTime.now();

  String get _formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              SlotsCubit(DioConsumer(dio: Dio()))
                ..loadSlots(widget.stadium.id!, _formattedDate),
        ),
        BlocProvider(create: (_) => BookingCubit()),
        BlocProvider(create: (_) => CheckoutCubit()),
      ],
      child: Builder(
        builder: (ctx) {
          return BlocListener<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutSuccess) {
                Navigator.pop(context);
                launchUrl(
                  Uri.parse(state.response.paymentUrl),
                  mode: LaunchMode.externalApplication,
                );
              } else if (state is CheckoutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل الحجز: ${state.error}'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // ── Handle ──────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // ── Header ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stadium,
                          color: Color(0xFF2E7D32),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.stadium.name ?? 'حجز ملعب',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Date Picker Row ──────────────────────────────────
                  _DateSelector(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() => _selectedDate = date);
                      ctx.read<BookingCubit>().clearSlots();
                      ctx.read<SlotsCubit>().loadSlots(
                        widget.stadium.id!,
                        DateFormat('yyyy-MM-dd').format(date),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Legend Row ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'الأوقات المتاحة',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const Spacer(),
                        _Legend(color: const Color(0xFF2E7D32), label: 'متاح'),
                        const SizedBox(width: 12),
                        _Legend(color: Colors.grey.shade300, label: 'محجوز'),
                      ],
                    ),
                  ),

                  // ── Minimum slots hint ───────────────────────────────
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      final count = context
                          .read<BookingCubit>()
                          .selectedSlots
                          .length;
                      if (count > 0 && count < 2) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'اختر فترة أخرى على الأقل (ساعة كاملة)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ).animate().fadeIn(duration: 200.ms),
                        );
                      }
                      return const SizedBox(height: 12);
                    },
                  ),

                  // ── Slots Grid ───────────────────────────────────────
                  Expanded(
                    child: BlocBuilder<SlotsCubit, SlotsState>(
                      builder: (context, state) {
                        if (state is SlotsLoading || state is SlotsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                            ),
                          );
                        }
                        if (state is SlotsFailure) {
                          return Center(
                            child: Text(
                              'حدث خطأ في تحميل المواعيد',
                              style: TextStyle(color: Colors.red.shade400),
                            ),
                          );
                        }
                        if (state is! SlotsSuccess) return const SizedBox();

                        final slots = state.response.slots;
                        if (slots.isEmpty) {
                          return const Center(
                            child: Text('لا توجد مواعيد متاحة لهذا اليوم'),
                          );
                        }

                        return BlocBuilder<BookingCubit, BookingState>(
                          builder: (context, bookingState) {
                            final selectedSlots = context
                                .read<BookingCubit>()
                                .selectedSlots;
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 2.2,
                                  ),
                              itemCount: slots.length,
                              itemBuilder: (context, i) {
                                final slot = slots[i];
                                final isSelected = selectedSlots.contains(slot);
                                return _SlotChip(
                                  slot: slot,
                                  isSelected: isSelected,
                                  index: i,
                                  onTap: slot.available
                                      ? () => context
                                            .read<BookingCubit>()
                                            .toggleSlot(slot)
                                      : null,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // ── Confirm Button ───────────────────────────────────
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, bookingState) {
                      final bookingCubit = context.read<BookingCubit>();
                      return AnimatedSwitcher(
                        duration: 300.ms,
                        child: bookingCubit.canConfirm
                            ? _ConfirmButton(
                                slots: bookingCubit.selectedSlots,
                                stadium: widget.stadium,
                                date: _formattedDate,
                              )
                            : const SizedBox(height: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Date Selector ──────────────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(14, (i) => today.add(Duration(days: i)));
    final dayNames = ['أحد', 'اثن', 'ثلاث', 'أرب', 'خمس', 'جمعة', 'سبت'];

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final date = dates[i];
          final isSelected =
              DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(selectedDate);

          return GestureDetector(
            onTap: () => onDateChanged(date),
            child: AnimatedContainer(
              duration: 250.ms,
              width: 54,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : Colors.black.withOpacity(0.08),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNames[date.weekday % 7],
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(
            delay: Duration(milliseconds: i * 30),
            duration: 200.ms,
          );
        },
      ),
    );
  }
}

// ─── Slot Chip ───────────────────────────────────────────────────────────────

class _SlotChip extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;

  const _SlotChip({
    required this.slot,
    required this.isSelected,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final available = slot.available;

    return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: 200.ms,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2E7D32)
                  : available
                  ? Colors.white
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : available
                    ? const Color(0xFF2E7D32).withOpacity(0.3)
                    : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '${slot.start} - ${slot.end}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : available
                      ? const Color(0xFF2E7D32)
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: index * 25),
          duration: 300.ms,
        )
        .scale(
          begin: const Offset(0.85, 0.85),
          delay: Duration(milliseconds: index * 25),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}

// ─── Legend Dot ──────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}

// ─── Confirm Button ───────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  final List<TimeSlot> slots;
  final StadiumModel stadium;
  final String date;

  const _ConfirmButton({
    required this.slots,
    required this.stadium,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final sortedSlots = List<TimeSlot>.from(slots)
      ..sort((a, b) => a.start.compareTo(b.start));
    final firstSlot = sortedSlots.first;
    final lastSlot = sortedSlots.last;

    return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: BlocBuilder<CheckoutCubit, CheckoutState>(
            builder: (context, checkoutState) {
              final isLoading = checkoutState is CheckoutLoading;

              return SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<CheckoutCubit>().checkout(
                            CheckoutRequest(
                              fieldId: stadium.id!,
                              userId:
                                  1, // replace with AppSession.userId when available
                              date: date,
                              startTime: firstSlot.start,
                              endTime: lastSlot.end,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(
                      0xFF2E7D32,
                    ).withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'تأكيد الحجز • ${firstSlot.start} - ${lastSlot.end}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.3, duration: 250.ms, curve: Curves.easeOut);
  }
}
