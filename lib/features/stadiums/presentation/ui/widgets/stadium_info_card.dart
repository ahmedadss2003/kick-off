import 'package:flutter/material.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// White info card shown on the details screen.
/// Displays stadium name and star rating.
class StadiumInfoCard extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoCard({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Name ───────────────────────────────────────────────────
          Text(
            stadium.name ?? 'ملعب',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if ((stadium.description ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              stadium.description!.trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF616161),
              ),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),

          // ── Rating row ─────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${stadium.rating?.toInt() ?? 0} / 10',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF424242),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (i) {
                final filled = i < ((stadium.rating ?? 0) / 2).round();
                return Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFC107),
                  size: 20,
                );
              }),
            ],
          ),
          if (stadium.distanceKm != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.place, size: 18, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  '${stadium.distanceKm!.toStringAsFixed(1)} كم عن موقعك',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // ── Action buttons row ─────────────────────────────────────
          Row(
            children: [
              _ActionButton(
                icon: Icons.location_on,
                label: stadium.distanceKm != null
                    ? 'الموقع\n${stadium.distanceKm!.toStringAsFixed(1)} كم عنك'
                    : 'افتح\nالموقع',
                backgroundColor: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFE53935),
                onTap: () => _openLocation(context, stadium),
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.phone,
                label: 'اتصال\n${_displayPhone(stadium)}',
                backgroundColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                onTap: () => _callPhone(context, stadium),
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.group,
                label: 'عدد اللاعبين\n${stadium.size ?? '–'}',
                backgroundColor: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1565C0),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _displayPhone(StadiumModel stadium) {
    final p = stadium.phone ?? stadium.owner?.phone;
    if (p == null || p.isEmpty) return '...';
    return p;
  }

  Future<void> _callPhone(BuildContext context, StadiumModel stadium) async {
    final raw = stadium.phone ?? stadium.owner?.phone;
    if (raw == null || raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الهاتف غير متاح')),
      );
      return;
    }
    final uri = Uri.parse('tel:$raw');
    try {
      final ok = await launchUrl(uri);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن بدء الاتصال')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء الاتصال')),
        );
      }
    }
  }

  Future<void> _openLocation(BuildContext context, StadiumModel stadium) async {
    final location = stadium.location;

    if (location == null || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الموقع غير متاح لهذا الملعب')),
      );
      return;
    }

    Uri? uri;

    // Case 1: Google Maps short/full URL (e.g. https://maps.app.goo.gl/...)
    if (location.startsWith('http')) {
      uri = Uri.tryParse(location);
    }
    // Case 2: "lat,lng" format (e.g. "30.0444,31.2357")
    else if (location.contains(',')) {
      final lat = stadium.latitude;
      final lng = stadium.longitude;
      if (lat != null && lng != null) {
        uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
        );
      }
    }

    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('صيغة الموقع غير مدعومة')));
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح تطبيق الخرائط')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء فتح الموقع')),
        );
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF424242),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
