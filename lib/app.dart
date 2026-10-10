import 'package:flutter/material.dart';

import 'constants.dart';
import 'controllers/weather_controller.dart';
import 'controllers/weather_scope.dart';
import 'screens/weather_screen.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, required this.controller});

  final WeatherController controller;

  @override
  Widget build(BuildContext context) {
    return WeatherScope(
      controller: controller,
      child: MaterialApp(
        title: 'Ob-havo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: kBlue),
        home: const WeatherScreen(),
      ),
    );
  }
}