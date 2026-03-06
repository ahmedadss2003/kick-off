import 'package:flutter/material.dart';

/// A small pill badge showing a rating number and a star icon.
/// Used on top of stadium images in the home list.
class RatingBadge extends StatelessWidget {
  final num? rating;

  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating != null ? '${rating!.toInt()}' : '–',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
        ],
      ),
    );
  }
}
