import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/weather_scope.dart';

/// Internet yo‘q va saqlangan ma’lumot ham yo‘q bo‘lganda ko‘rinadi.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.onRetry, required this.onSearch});

  final VoidCallback onRetry;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final s = WeatherScope.of(context).s;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 72, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              s.errorTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              s.errorBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kText,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: const StadiumBorder(),
              ),
              child: Text(s.retry),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onSearch,
              child: Text(
                s.chooseAnotherCity,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}