import 'package:flutter/material.dart';

// Dizayndagi asosiy ranglar
const kBackground = Color(0xFFE9F1FB);
const kBlue = Color(0xFF7FBDEB);
const kSun = Color(0xFFFFD93B);
const kMoon = Color(0xFFFFE08A);
const kIcon = Color(0xFF6FA8DC);
const kText = Color(0xFF3A4A5A);

// API manzillari (hammasi bepul, kalit kerak emas)
class ApiUrls {
  ApiUrls._();

  static const forecast = 'https://api.open-meteo.com/v1/forecast';
  static const geocoding = 'https://geocoding-api.open-meteo.com/v1/search';
  static const reverseGeocoding =
      'https://api.bigdatacloud.net/data/reverse-geocode-client';
}