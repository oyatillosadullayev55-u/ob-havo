import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

const kBlue = Color(0xFF7FBDEB);
const kSun = Color(0xFFFFD93B);
const kIcon = Color(0xFF6FA8DC);
const kText = Color(0xFF3A4A5A);

enum Kind { sun, partly, cloud, rain, storm }

class Hour {
  final String time;
  final Kind kind;
  final String rain;
  final String wind;
  const Hour(this.time, this.kind, this.rain, this.wind);
}

class Day {
  final String name;
  final String rain;
  final String wind;
  final Kind kind;
  final String temp;
  const Day(this.name, this.rain, this.wind, this.kind, this.temp);
}

const hours = [
  Hour('Now', Kind.sun, '14%', '4 m/s'),
  Hour('16:00', Kind.partly, '37%', '7 m/s'),
  Hour('17:00', Kind.sun, '23%', '4 m/s'),
  Hour('18:00', Kind.cloud, '45%', '6 m/s'),
  Hour('19:00', Kind.rain, '75%', '7 m/s'),
];

const days = [
  Day('Today', '45%', '7 m/s', Kind.partly, '29°/16°'),
  Day('Thu', '7%', '3 m/s', Kind.sun, '31°/19°'),
  Day('Fri', '15%', '5 m/s', Kind.partly, '28°/15°'),
  Day('Sat', '44%', '2 m/s', Kind.cloud, '26°/15°'),
  Day('Sun', '87%', '8 m/s', Kind.rain, '23°/14°'),
  Day('Mon', '89%', '6 m/s', Kind.storm, '22°/13°'),
];

class WeatherIcon extends StatelessWidget {
  final Kind kind;
  final double size;
  const WeatherIcon(this.kind, {super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case Kind.sun:
        return Icon(Icons.wb_sunny_outlined, color: kSun, size: size);
      case Kind.partly:
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
      case Kind.cloud:
        return Icon(Icons.cloud_outlined, color: kIcon, size: size);
      case Kind.rain:
        return Icon(Icons.cloudy_snowing, color: kIcon, size: size);
      case Kind.storm:
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

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8CC6F0), Color(0xFF6AAEE4)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: 10),
                  _current(),
                  const SizedBox(height: 18),
                  _hourlyCard(),
                  const SizedBox(height: 16),
                  _dailyCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('City/Country',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Icon(Icons.menu, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Wed, May 26, 15:00',
              style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _current() {
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

  Widget _hourlyCard() {
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

  Widget _dailyCard() {
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