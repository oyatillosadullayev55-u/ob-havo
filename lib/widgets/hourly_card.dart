import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/l10n.dart';
import '../utils/units.dart';
import '../utils/weather_palette.dart';
import 'app_card.dart';
import 'weather_icon.dart';

/// Keyingi 24 soat: yon tomonga surib ko‘riladi, ekranda 5 tasi ko‘rinadi.
class HourlyCard extends StatelessWidget {
  const HourlyCard({super.key, required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final p = c.palette;

    return AppCard(
      palette: p,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: LayoutBuilder(
        builder: (context, box) {
          final itemWidth = (box.maxWidth - 12) / 5;
          return SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: forecast.hours.length,
              itemBuilder: (context, index) => SizedBox(
                width: itemWidth,
                child: _HourItem(
                  hour: forecast.hours[index],
                  isNow: index == 0,
                  palette: p,
                  s: c.s,
                  tempUnit: c.tempUnit,
                  windUnit: c.windUnit,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  const _HourItem({
    required this.hour,
    required this.isNow,
    required this.palette,
    required this.s,
    required this.tempUnit,
    required this.windUnit,
  });

  final HourWeather hour;
  final bool isNow;
  final WeatherPalette palette;
  final S s;
  final TempUnit tempUnit;
  final WindUnit windUnit;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final rain = hour.precipProb == null ? '–' : '${hour.precipProb}%';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isNow ? s.now : s.clock(hour.time),
          style: TextStyle(
            color: p.onCard,
            fontSize: 12,
            fontWeight: isNow ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        WeatherIcon(
          kind: hour.kind,
          isDay: hour.isDay,
          size: 28,
          line: p.accent,
          fill: p.card,
        ),
        const SizedBox(height: 6),
        Text(
          Units.tempText(hour.temperature, tempUnit),
          style: TextStyle(
            color: p.onCard,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Icon(Icons.water_drop_outlined, size: 14, color: p.accent),
        Text(rain, style: TextStyle(color: p.onCard, fontSize: 10)),
        const SizedBox(height: 6),
        Icon(Icons.air, size: 14, color: p.accent),
        Text(
          s.windText(hour.windSpeed, windUnit),
          style: TextStyle(color: p.onCard, fontSize: 10),
        ),
      ],
    );
  }
}