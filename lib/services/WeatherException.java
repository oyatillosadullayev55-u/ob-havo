import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/weather_models.dart';

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => 'WeatherException: $message';
}

/// Open-Meteo (prognoz va shahar qidirish) hamda BigDataCloud (koordinatadan
/// shahar nomini topish) bilan ishlaydi. API kalit kerak emas.
class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await _client.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw WeatherException('HTTP ${response.statusCode}');
    }
    // Kirill va o‘zbek harflari to‘g‘ri chiqishi uchun UTF-8 ni o‘zimiz ochamiz
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const WeatherException('Kutilmagan javob');
    }
    return decoded;
  }

  /// To‘liq prognoz (hozir + soatlik + kunlik). Harorat °C, shamol m/s.
  Future<Map<String, dynamic>> fetchForecast(GeoPlace place) {
    final uri = Uri.parse(ApiUrls.forecast).replace(queryParameters: {
      'latitude': place.latitude.toStringAsFixed(4),
      'longitude': place.longitude.toStringAsFixed(4),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'is_day,precipitation,weather_code,pressure_msl,wind_speed_10m,'
          'wind_direction_10m,wind_gusts_10m',
      'hourly': 'temperature_2m,precipitation_probability,weather_code,'
          'wind_speed_10m,is_day',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,sunrise,'
          'sunset,uv_index_max,precipitation_probability_max,'
          'wind_speed_10m_max,precipitation_sum',
      'timezone': 'auto',
      'forecast_days': '14',
      'wind_speed_unit': 'ms',
    });
    return _getJson(uri);
  }

  /// Shahar nomi bo‘yicha qidirish
  Future<List<GeoPlace>> searchCity(String query, String languageCode) async {
    final text = query.trim();
    if (text.length < 2) return const [];

    final uri = Uri.parse(ApiUrls.geocoding).replace(queryParameters: {
      'name': text,
      'count': '12',
      'language': languageCode,
      'format': 'json',
    });
    final json = await _getJson(uri);
    final results = json['results'];
    if (results is! List) return const [];

    return [
      for (final item in results)
        if (item is Map<String, dynamic>) GeoPlace.fromGeocoding(item),
    ];
  }

  /// GPS koordinatasidan shahar nomini topadi. Topolmasa ham xato bermaydi:
  /// ob-havo koordinata bo‘yicha baribir ishlayveradi.
  Future<GeoPlace> reverseGeocode(
    double latitude,
    double longitude,
    String languageCode,
  ) async {
    var name = '';
    var country = '';
    try {
      final uri =
          Uri.parse(ApiUrls.reverseGeocoding).replace(queryParameters: {
        'latitude': latitude.toStringAsFixed(5),
        'longitude': longitude.toStringAsFixed(5),
        'localityLanguage': languageCode,
      });
      final json = await _getJson(uri);
      name = _firstText(json, const ['city', 'locality', 'principalSubdivision']);
      country = _firstText(json, const ['countryName']);
    } catch (_) {
      // Nom topilmasa "Mening joylashuvim" deb ko‘rsatiladi
    }
    return GeoPlace(
      name: name,
      country: country,
      latitude: latitude,
      longitude: longitude,
      isCurrent: true,
    );
  }

  static String _firstText(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}