import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/weather_models.dart';

/// Ob-havo holatiga va kun/tun vaqtiga qarab o‘zgaradigan ranglar.
class WeatherPalette {
  const WeatherPalette({
    required this.top,
    required this.bottom,
    required this.card,
    required this.onCard,
    required this.muted,
    required this.accent,
  });

  const WeatherPalette.day(this.top, this.bottom)
      : card = Colors.white,
        onCard = kText,
        muted = const Color(0xFF8A9BAE),
        accent = kIcon;

  const WeatherPalette.night(this.top, this.bottom)
      : card = const Color(0xFF1E2A52),
        onCard = const Color(0xFFEAF0FF),
        muted = const Color(0xFF9AA9D0),
        accent = const Color(0xFF8DB8FF);

  /// Fon gradienti (tepa va past)
  final Color top;
  final Color bottom;

  /// Kartochka foni, matn, xira matn va ikonka rangi
  final Color card;
  final Color onCard;
  final Color muted;
  final Color accent;

  LinearGradient get gradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  );

  static WeatherPalette of(WeatherKind kind, bool isDay) {
    if (!isDay) {
      return switch (kind) {
        WeatherKind.clear || WeatherKind.partly => const WeatherPalette.night(
          Color(0xFF2B3F7A),
          Color(0xFF111A3C),
        ),
        WeatherKind.cloudy || WeatherKind.fog => const WeatherPalette.night(
          Color(0xFF3A4766),
          Color(0xFF1C2338),
        ),
        WeatherKind.drizzle ||
        WeatherKind.rain ||
        WeatherKind.storm =>
        const WeatherPalette.night(Color(0xFF2E3A55), Color(0xFF151C2E)),
        WeatherKind.snow => const WeatherPalette.night(
          Color(0xFF4A5E85),
          Color(0xFF222C47),
        ),
      };
    }
    return switch (kind) {
      WeatherKind.clear =>
      const WeatherPalette.day(Color(0xFF8CC6F0), Color(0xFF5FA4E2)),
      WeatherKind.partly =>
      const WeatherPalette.day(Color(0xFF8DBDE8), Color(0xFF6397CC)),
      WeatherKind.cloudy =>
      const WeatherPalette.day(Color(0xFFA3B8CB), Color(0xFF7690A8)),
      WeatherKind.fog =>
      const WeatherPalette.day(Color(0xFFB5C3CE), Color(0xFF8FA1B0)),
      WeatherKind.drizzle || WeatherKind.rain =>
      const WeatherPalette.day(Color(0xFF8FA6BF), Color(0xFF5D7592)),
      WeatherKind.snow =>
      const WeatherPalette.day(Color(0xFFBCD7EE), Color(0xFF8DB1D3)),
      WeatherKind.storm =>
      const WeatherPalette.day(Color(0xFF6D7B96), Color(0xFF3D4764)),
    };
  }
}