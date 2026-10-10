import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/units.dart';
import 'app_card.dart';
import 'detail_tile.dart';

/// Qo‘shimcha ma’lumotlar: his qilinishi, namlik, shamol, bosim, UV, yog‘in.
class DetailsGrid extends StatelessWidget {
  const DetailsGrid({super.key, required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final p = c.palette;
    final current = forecast.current;
    final today = forecast.days.first;
    final uv = today.uvIndex;

    final tiles = <Widget>[
      DetailTile(
        palette: p,
        icon: Icons.thermostat,
        label: s.feelsLike,
        value: Units.tempText(current.feelsLike, c.tempUnit),
      ),
      DetailTile(
        palette: p,
        icon: Icons.water_drop_outlined,
        label: s.humidity,
        value: '${current.humidity}%',
      ),
      DetailTile(
        palette: p,
        icon: Icons.air,
        label: s.wind,
        value: s.windText(current.windSpeed, c.windUnit),
        caption:
        '${s.compass(current.windDirection)}, ${s.gusts} ${s.windText(current.windGusts, c.windUnit)}',
        // Shamol qayoqqa esayotganini ko‘rsatuvchi strelka
        trailing: Transform.rotate(
          angle: (current.windDirection + 180) * math.pi / 180,
          child: Icon(Icons.navigation, size: 16, color: p.accent),
        ),
      ),
      DetailTile(
        palette: p,
        icon: Icons.compress,
        label: s.pressure,
        value: '${current.pressure.round()} ${s.pressureUnit}',
      ),
      DetailTile(
        palette: p,
        icon: Icons.wb_sunny_outlined,
        label: s.uvIndex,
        value: uv == null ? '–' : uv.round().toString(),
        caption: uv == null ? null : s.uvLabel(uv),
      ),
      DetailTile(
        palette: p,
        icon: Icons.umbrella,
        label: s.precipitation,
        value: '${today.precipSum.toStringAsFixed(1)} ${s.mm}',
      ),
    ];

    return AppCard(
      palette: p,
      child: LayoutBuilder(
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
    );
  }
}