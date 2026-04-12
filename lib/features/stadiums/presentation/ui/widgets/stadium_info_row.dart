import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// The bottom section of StadiumCard: name, price, and distance chips.
class StadiumInfoRow extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoRow({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Stadium name ─────────────────────────────────────────────
          Text(
            stadium.name ?? 'ملعب',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 8.h),

          // ── Chips ────────────────────────────────────────────────────
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            alignment: WrapAlignment.end,
            textDirection: TextDirection.rtl,
            children: [
              _Chip(
                label: '${stadium.price?.toInt() ?? 0} EGP/ساعة',
                backgroundColor: AppColors.teal.withValues(alpha: 0.08),
                textColor: AppColors.teal,
              ),
              if (stadium.distanceKm != null)
                _Chip(
                  label: '${stadium.distanceKm!.toStringAsFixed(1)} كم',
                  backgroundColor: AppColors.yellow.withValues(alpha: 0.1),
                  textColor: AppColors.yellow,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small rounded chip with custom colors.
class _Chip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _Chip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: textColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
