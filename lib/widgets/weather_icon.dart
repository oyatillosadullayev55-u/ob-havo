import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/weather_models.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherKind kind;
  final double size;

  const WeatherIcon(this.kind, {super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case WeatherKind.sun:
        return Icon(Icons.wb_sunny_outlined, color: kSun, size: size);
      case WeatherKind.partly:
        return SizedBox(
          width: size + 6,
          height: size,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Icon(Icons.wb_sunny_outlined,
                    color: kSun, size: size * 0.6),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(Icons.cloud_outlined, color: kIcon, size: size),
              ),
            ],
          ),
        );
      case WeatherKind.cloud:
        return Icon(Icons.cloud_outlined, color: kIcon, size: size);
      case WeatherKind.rain:
        return Icon(Icons.cloudy_snowing, color: kIcon, size: size);
      case WeatherKind.storm:
        return SizedBox(
          width: size + 6,
          height: size,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Icon(Icons.cloud_outlined, color: kIcon, size: size),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.bolt, color: kSun, size: size * 0.55),
              ),
            ],
          ),
        );
    }
  }
}