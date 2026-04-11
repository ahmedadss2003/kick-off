import 'package:flutter/material.dart';
import 'package:kickoff/core/utils/app_colors.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:url_launcher/url_launcher.dart';

class StadiumInfoCard extends StatelessWidget {
  final StadiumModel stadium;

  const StadiumInfoCard({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.02),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name & Rating Header ───────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stadium.name ?? 'ملعب',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${stadium.rating?.toInt() ?? 0}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Description ──────────────────────────────────────────
          if ((stadium.description ?? '').trim().isNotEmpty) ...[
            Text(
              stadium.description!.trim(),
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
          ],

          // ── Distance Row ───────────────────────────────────────────
          if (stadium.distanceKm != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.place_rounded, size: 14, color: AppColors.teal),
                ),
                const SizedBox(width: 8),
                Text(
                  '${stadium.distanceKm!.toStringAsFixed(1)} كم عن موقعك الحالي',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 24),

          // ── Action Buttons Row ─────────────────────────────────────
          Row(
            children: [
              _ActionButton(
                icon: Icons.location_on_rounded,
                label: 'الموقع',
                backgroundColor: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFE53935),
                onTap: () => _openLocation(context, stadium),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.phone_rounded,
                label: 'اتصال',
                backgroundColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                onTap: () => _callPhone(context, stadium),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.group_rounded,
                label: stadium.size ?? 'متاح',
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
