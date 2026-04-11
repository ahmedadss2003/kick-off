import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/rating_badge.dart';

/// The top image section of StadiumCard with a rating overlay badge.
class StadiumImageArea extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumImageArea({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Stack(
        children: [
          // ── Image / placeholder (square thumb — fits 3-column grid) ─
          AspectRatio(
            aspectRatio: 1,
            child: stadium.images.isNotEmpty
                ? Image.network(
                    stadium.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),

          // ── Rating badge (top-left) ──────────────────────────────────
          Positioned(
            top: 6,
            left: 6,
            child: RatingBadge(rating: stadium.rating),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: Icon(Icons.sports_soccer, size: 56, color: Color(0xFF2E7D32)),
      ),
    );
  }
}
