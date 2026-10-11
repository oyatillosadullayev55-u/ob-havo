import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

enum LocationFailure { serviceDisabled, denied, deniedForever, timeout, unknown }

class LocationException implements Exception {
  const LocationException(this.failure);

  final LocationFailure failure;

  @override
  String toString() => 'LocationException: ${failure.name}';
}

/// GPS orqali joylashuvni aniqlaydi (ruxsat so‘raydi).
/// Android, iOS va brauzerda ishlaydi.
class LocationService {
  Future<Position> currentPosition() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw const LocationException(LocationFailure.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const LocationException(LocationFailure.denied);
      }
      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(LocationFailure.deniedForever);
      }

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 12),
          ),
        );
      } on TimeoutException {
        // Brauzerda "oxirgi ma’lum joylashuv" tushunchasi yo‘q
        if (!kIsWeb) {
          final last = await Geolocator.getLastKnownPosition();
          if (last != null) return last;
        }
        throw const LocationException(LocationFailure.timeout);
      }
    } on LocationException {
      rethrow;
    } catch (_) {
      throw const LocationException(LocationFailure.unknown);
    }
  }

  Future<void> openSettings(LocationFailure failure) async {
    // Brauzerda sozlamalarni dasturdan ochib bo‘lmaydi
    if (kIsWeb) return;
    if (failure == LocationFailure.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }
}