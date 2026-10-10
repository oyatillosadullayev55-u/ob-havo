import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/units.dart';
import 'detail_tile.dart';
import 'weather_icon.dart';

/// Kunlik prognoz qatori bosilganda pastdan chiqadigan oyna.
void showDaySheet(
    BuildContext context,
    DayWeather day, {
      required bool isToday,
    }) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DaySheet(day: day, isToday: isToday),
  );
}

class DaySheet extends StatelessWidget {
  const DaySheet({super.key, required this.day, required this.isToday});

  final DayWeather day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final p = c.palette;
    final unit = c.tempUnit;
    final uv = day.uvIndex;
    final sunrise = day.sunrise;
    final sunset = day.sunset;

    final tiles = <Widget>[
      DetailTile(
        palette: p,
        icon: Icons.umbrella,
        label: s.chanceOfRain,
        value: day.precipProb == null ? '–' : '${day.precipProb}%',
      ),
      DetailTile(
        palette: p,
        icon: Icons.water_drop_outlined,
        label: s.precipitation,
        value: '${day.precipSum.toStringAsFixed(1)} ${s.mm}',
      ),
      DetailTile(
        palette: p,
        icon: Icons.air,
        label: s.maxWind,
        value: s.windText(day.windMax, c.windUnit),
      ),
      if (uv != null)
        DetailTile(
          palette: p,
          icon: Icons.wb_sunny_outlined,
          label: s.uvIndex,
          value: uv.round().toString(),
          caption: s.uvLabel(uv),
        ),
      if (sunrise != null)
        DetailTile(
          palette: p,
          icon: Icons.wb_twilight,
          label: s.sunrise,
          value: s.clock(sunrise),
        ),
      if (sunset != null)
        DetailTile(
          palette: p,
          icon: Icons.nights_stay_outlined,
          label: s.sunset,
          value: s.clock(sunset),
        ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: p.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                WeatherIcon(
                  kind: day.kind,
                  size: 56,
                  line: p.accent,
                  fill: p.card,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isToday ? s.today : s.weekdayFull(day.date.weekday),
                        style: TextStyle(
                          color: p.onCard,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${s.monthDay(day.date)}, ${s.condition(day.kind)}',
                        style: TextStyle(color: p.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${Units.tempText(day.tempMax, unit)}/${Units.tempText(day.tempMin, unit)}',
                  style: TextStyle(
                    color: p.onCard,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, box) {
                final width = (box.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final tile in tiles) SizedBox(width: width, child: tile),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}