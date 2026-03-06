import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';

/// Image carousel at the top of StadiumDetailsScreen.
/// Shows a PageView of images with dot indicators.
class StadiumImageCarousel extends StatefulWidget {
  final StadiumModel stadium;

  const StadiumImageCarousel({super.key, required this.stadium});

  @override
  State<StadiumImageCarousel> createState() => _StadiumImageCarouselState();
}

class _StadiumImageCarouselState extends State<StadiumImageCarousel> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  List<String> get _images => widget.stadium.images;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── PageView ─────────────────────────────────────────────────
        SizedBox(
          height: 280,
          child: _images.isEmpty
              ? _buildPlaceholder()
              : PageView.builder(
                  controller: _controller,
                  itemCount: _images.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => Image.network(
                    _images[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
                ),
        ),

        // ── Dot indicators (bottom center) ──────────────────────────
        if (_images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentPage ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? const Color(0xFF2E7D32)
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

        // ── Next arrow (right side) ──────────────────────────────────
        if (_images.length > 1)
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: Icon(Icons.sports_soccer, size: 80, color: Color(0xFF2E7D32)),
      ),
    );
  }
}
