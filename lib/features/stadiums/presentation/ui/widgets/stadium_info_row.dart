import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// The bottom section of StadiumCard: name, price, and distance chips.
class StadiumInfoRow extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoRow({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // RTL: right-align
        children: [
          // ── Stadium name ─────────────────────────────────────────────
          Text(
            stadium.name ?? 'ملعب',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),

          // ── Chips (wrap — avoids overflow in 3-column grid) ───────────
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.end,
            textDirection: TextDirection.rtl,
            children: [
              _Chip(
                label: '${stadium.price?.toInt() ?? 0} EGP/Hour',
                backgroundColor: const Color(0xFFE8F5E9),
                textColor: const Color(0xFF2E7D32),
              ),
              if (stadium.distanceKm != null)
                _Chip(
                  label: '${stadium.distanceKm!.toStringAsFixed(1)} كم',
                  backgroundColor: const Color(0xFFF5F5F5),
                  textColor: Colors.red,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
