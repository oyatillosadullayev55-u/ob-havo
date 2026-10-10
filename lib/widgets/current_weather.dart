import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/units.dart';
import 'weather_icon.dart';

/// Eng tepadagi katta qism: ikonka, harorat va bugungi eng yuqori/past harorat.
class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key, required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final unit = c.tempUnit;
    final current = forecast.current;
    final today = forecast.days.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedWeatherIcon(
                kind: current.kind,
                isDay: current.isDay,
                size: 92,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  // Harorat 0 dan hozirgi qiymatgacha sanab chiqadi
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: Units.temp(current.temperature, unit),
                    ),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '${value.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 76,
                        fontWeight: FontWeight.w200,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Units.tempText(today.tempMax, unit),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Container(
                    width: 38,
                    height: 1.2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                  ),
                  Text(
                    Units.tempText(today.tempMin, unit),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            s.condition(current.kind),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}