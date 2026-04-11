import 'package:flutter/material.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

class StadiumAmenitiesRow extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumAmenitiesRow({super.key, required this.stadium});

  bool get _is24h {
    if (stadium.openingT == null || stadium.closingT == null) return false;
    return stadium.openingT!.startsWith('00') &&
        stadium.closingT!.startsWith('00');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AmenityChip(
            iconLabel: 'P',
            label: 'موقف\nسيارات',
            backgroundColor: const Color(0xFFFFF8E1),
            iconColor: const Color(0xFFF9A825),
            isText: true,
          ),
          _AmenityChip(
            label: _is24h
                ? 'متاح 24/7'
                : 'متاح\n${stadium.openingT ?? '–'} - ${stadium.closingT ?? '–'}',
            backgroundColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            iconData: Icons.access_time_rounded,
          ),
          _AmenityChip(
            label: 'كرة قدم',
            backgroundColor: const Color(0xFFE8F5E9),
            iconColor: AppColors.teal,
            iconData: Icons.sports_soccer_rounded,
          ),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final IconData? iconData;
  final String? iconLabel;
  final bool isText;

  const _AmenityChip({
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    this.iconData,
    this.iconLabel,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isText
                ? Text(
                    iconLabel ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: iconColor,
                    ),
                  )
                : Icon(iconData, color: iconColor, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
