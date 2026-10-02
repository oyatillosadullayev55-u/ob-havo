import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../widgets/current_weather.dart';
import '../widgets/daily_card.dart';
import '../widgets/header_section.dart';
import '../widgets/hourly_card.dart';

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
              child: const Column(
                children: [
                  HeaderSection(),
                  SizedBox(height: 10),
                  CurrentWeather(),
                  SizedBox(height: 18),
                  HourlyCard(),
                  SizedBox(height: 16),
                  DailyCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}