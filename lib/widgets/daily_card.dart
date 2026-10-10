import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/l10n.dart';
import '../utils/units.dart';
import '../utils/weather_palette.dart';
import 'app_card.dart';
import 'day_sheet.dart';
import 'weather_icon.dart';

/// Kunlik prognoz. "More" bosilsa 14 kungacha ochiladi,
/// qatorni bossangiz o‘sha kunning tafsilotlari chiqadi.
class DailyCard extends StatefulWidget {
  const DailyCard({super.key, required this.forecast});

  final Forecast forecast;

  @override
  State<DailyCard> createState() => _DailyCardState();
}

class _DailyCardState extends State<DailyCard> {
  static const _collapsedCount = 6;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final p = c.palette;
    final days = widget.forecast.days;
    final shown = _expanded ? days : days.take(_collapsedCount).toList();
    final canExpand = days.length > _collapsedCount;

    return AppCard(
      palette: p,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                for (var i = 0; i < shown.length; i++)
                  _DayRow(
                    day: shown[i],
                    isToday: i == 0,
                    palette: p,
                    s: s,
                    tempUnit: c.tempUnit,
                    windUnit: c.windUnit,
                    onTap: () => showDaySheet(
                      context,
                      shown[i],
                      isToday: i == 0,
                    ),
                  ),
              ],
            ),
          ),
          if (canExpand) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _expanded ? s.less : s.more,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.isToday,
    required this.palette,
    required this.s,
    required this.tempUnit,
    required this.windUnit,
    required this.onTap,
  });

  final DayWeather day;
  final bool isToday;
  final WeatherPalette palette;
  final S s;
  final TempUnit tempUnit;
  final WindUnit windUnit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final rain = day.precipProb == null ? '–' : '${day.precipProb}%';
    final temps =
        '${Units.tempText(day.tempMax, tempUnit)}/${Units.tempText(day.tempMin, tempUnit)}';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                isToday ? s.today : s.weekdayShort(day.date.weekday),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: p.onCard,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.water_drop_outlined, size: 13, color: p.accent),
            const SizedBox(width: 3),
            SizedBox(
              width: 30,
              child: Text(
                rain,
                style: TextStyle(color: p.onCard, fontSize: 10),
              ),
            ),
            Icon(Icons.air, size: 13, color: p.accent),
            const SizedBox(width: 3),
            SizedBox(
              width: 40,
              child: Text(
                s.windText(day.windMax, windUnit),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.onCard, fontSize: 10),
              ),
            ),
            const Spacer(),
            WeatherIcon(
              kind: day.kind,
              size: 26,
              line: p.accent,
              fill: p.card,
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 62,
              child: Text(
                temps,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: p.onCard,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}