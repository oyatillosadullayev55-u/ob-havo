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
        title: 'Ob-havo: 14 kunlik ob-havo prognozi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: kBlue),
        // Brauzer yoki planshetda ekran keng bo‘ladi: ilova telefon kengligida,
        // o‘rtada turadi, yon tomonlar esa shu fon gradienti bilan to‘ladi.
        builder: (context, child) {
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: controller.palette.gradient,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: child,
                  ),
                ),
              );
            },
          );
        },
        home: const WeatherScreen(),
      ),
    );
  }
}