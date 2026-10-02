import 'package:flutter/material.dart';
import '../constants.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, color: kSun, size: 46),
          const SizedBox(width: 10),
          const Text('26°',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.w300,
                  height: 1.1)),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('29°', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                width: 36,
                child: Divider(color: Colors.white, height: 6, thickness: 1),
              ),
              Text('16°',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}