import 'package:flutter/material.dart';

import '../utils/weather_palette.dart';

/// Oq (kechasi to‘q) yumaloq kartochka. Ichidagi InkWell to‘lqini ko‘rinishi
/// uchun Material ishlatilgan.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.palette,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final WeatherPalette palette;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: palette.card,
        elevation: 3,
        shadowColor: const Color(0x33000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}