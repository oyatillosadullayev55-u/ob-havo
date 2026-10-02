import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/weather_data.dart';
import 'weather_icon.dart';

class HourlyCard extends StatelessWidget {
  const HourlyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: hours.map((h) {
          return Column(
            children: [
              Text(h.time,
                  style: const TextStyle(
                      color: kText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              WeatherIcon(h.kind, size: 26),
              const SizedBox(height: 8),
              const Icon(Icons.water_drop_outlined, color: kIcon, size: 14),
              Text(h.rain, style: const TextStyle(color: kText, fontSize: 9)),
              const SizedBox(height: 6),
              const Icon(Icons.air, color: kIcon, size: 14),
              Text(h.wind, style: const TextStyle(color: kText, fontSize: 9)),
            ],
          );
        }).toList(),
      ),
    );
  }
}