import 'package:flutter/material.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// The bottom section of StadiumCard: name, price, and distance chips.
class StadiumInfoRow extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoRow({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Stadium name ─────────────────────────────────────────────
          Text(
            stadium.name ?? 'ملعب',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),

          // ── Chips ────────────────────────────────────────────────────
          Wrap(
            spacing: 6,
            runSpacing: 6,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
