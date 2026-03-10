import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// Horizontal row of amenity chips for a stadium.
/// Infers amenities from the stadium data (parking, 24/7, sport type).
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AmenityChip(
            icon: 'P',
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
            iconColor: const Color(0xFF2E7D32),
            iconData: Icons.sports_soccer,
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
  final String? icon;
  final bool isText;

  const _AmenityChip({
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    this.iconData,
    this.iconLabel,
    this.icon,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: isText
                ? Text(
                    iconLabel ?? '',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  )
                : Icon(iconData, color: iconColor, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Color(0xFF424242)),
        ),
      ],
    );
  }
}
