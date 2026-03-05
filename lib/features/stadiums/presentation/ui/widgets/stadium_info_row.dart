import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// The bottom section of StadiumCard: name, price, and distance chips.
class StadiumInfoRow extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoRow({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // RTL: right-align
        children: [
          // ── Stadium name ─────────────────────────────────────────────
          Text(
            stadium.name ?? 'ملعب',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),

          // ── Chips row (price + distance) ─────────────────────────────
          Row(
            textDirection: TextDirection.rtl,
            children: [
              // Price chip (green)
              _Chip(
                label: '${stadium.price?.toInt() ?? 0} ج/ساعة',
                backgroundColor: const Color(0xFFE8F5E9),
                textColor: const Color(0xFF2E7D32),
              ),

              // Directional arrow between chips
              const SizedBox(width: 8),
              const Icon(Icons.arrow_back, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 8),

              // Distance chip (grey) — only shown if distance is available
              if (stadium.distanceKm != null)
                _Chip(
                  label: '${stadium.distanceKm!.toStringAsFixed(1)} كم عنك',
                  backgroundColor: const Color(0xFFF5F5F5),
                  textColor: const Color(0xFF757575),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
