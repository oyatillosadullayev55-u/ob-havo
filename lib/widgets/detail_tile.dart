import 'package:flutter/material.dart';

import '../utils/weather_palette.dart';

/// Kichik ma’lumot katagi: namlik, bosim, UV va hokazo uchun.
class DetailTile extends StatelessWidget {
  const DetailTile({
    super.key,
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
    this.caption,
    this.trailing,
  });

  final WeatherPalette palette;
  final IconData icon;
  final String label;
  final String value;
  final String? caption;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.onCard.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: palette.accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: palette.muted, fontSize: 12),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: palette.onCard,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                caption!,
                style: TextStyle(color: palette.muted, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}