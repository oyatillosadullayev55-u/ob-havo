import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/weather_data.dart';
import 'weather_icon.dart';

class DailyCard extends StatelessWidget {
  const DailyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          ...days.map((d) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(d.name,
                        style: const TextStyle(
                            color: kText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ),
                  const Icon(Icons.water_drop_outlined, color: kIcon, size: 12),
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 30,
                    child: Text(d.rain,
                        style: const TextStyle(color: kText, fontSize: 9)),
                  ),
                  const Icon(Icons.air, color: kIcon, size: 12),
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 38,
                    child: Text(d.wind,
                        style: const TextStyle(color: kText, fontSize: 9)),
                  ),
                  const Spacer(),
                  WeatherIcon(d.kind, size: 24),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 56,
                    child: Text(d.temp,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: kText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          SizedBox(
            width: 100,
            height: 30,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('More', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}