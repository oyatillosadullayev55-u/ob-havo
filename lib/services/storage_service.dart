import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_models.dart';
import '../utils/l10n.dart';
import '../utils/units.dart';

/// Sozlamalar, tanlangan shahar va oxirgi prognozni telefonda saqlaydi.
class StorageService {
  StorageService._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    return StorageService._(prefs);
  }

  static const _kLanguage = 'language';
  static const _kTempUnit = 'temp_unit';
  static const _kWindUnit = 'wind_unit';
  static const _kUseGps = 'use_gps';
  static const _kPlace = 'place';
  static const _kFavorites = 'favorites';
  static const _kForecast = 'forecast_cache';

  // ---- Sozlamalar ----
  AppLanguage? get language => AppLanguage.fromCode(_prefs.getString(_kLanguage));

  Future<void> setLanguage(AppLanguage value) =>
      _prefs.setString(_kLanguage, value.code);

  TempUnit get tempUnit {
    final index = _prefs.getInt(_kTempUnit) ?? 0;
    return index >= 0 && index < TempUnit.values.length
        ? TempUnit.values[index]
        : TempUnit.celsius;
  }

  Future<void> setTempUnit(TempUnit value) =>
      _prefs.setInt(_kTempUnit, value.index);

  WindUnit get windUnit {
    final index = _prefs.getInt(_kWindUnit) ?? 0;
    return index >= 0 && index < WindUnit.values.length
        ? WindUnit.values[index]
        : WindUnit.ms;
  }

  Future<void> setWindUnit(WindUnit value) =>
      _prefs.setInt(_kWindUnit, value.index);

  bool get useGps => _prefs.getBool(_kUseGps) ?? true;

  Future<void> setUseGps(bool value) => _prefs.setBool(_kUseGps, value);

  // ---- Shaharlar ----
  GeoPlace? get place {
    final raw = _prefs.getString(_kPlace);
    if (raw == null) return null;
    try {
      return GeoPlace.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> setPlace(GeoPlace value) =>
      _prefs.setString(_kPlace, jsonEncode(value.toJson()));

  List<GeoPlace> get favorites {
    final raw = _prefs.getString(_kFavorites);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in list)
          GeoPlace.fromJson(item as Map<String, dynamic>),
      ];
    } catch (_) {
      return [];
    }
  }

  Future<void> setFavorites(List<GeoPlace> value) => _prefs.setString(
    _kFavorites,
    jsonEncode([for (final place in value) place.toJson()]),
  );

  // ---- Oxirgi prognoz (internet bo‘lmaganda ko‘rsatish uchun) ----
  Forecast? get cachedForecast {
    final raw = _prefs.getString(_kForecast);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Forecast.fromApi(
        map['data'] as Map<String, dynamic>,
        GeoPlace.fromJson(map['place'] as Map<String, dynamic>),
        fetchedAt: DateTime.parse(map['fetchedAt'] as String),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveForecast(
      Map<String, dynamic> data,
      GeoPlace place,
      DateTime fetchedAt,
      ) =>
      _prefs.setString(
        _kForecast,
        jsonEncode({
          'place': place.toJson(),
          'fetchedAt': fetchedAt.toIso8601String(),
          'data': data,
        }),
      );
}