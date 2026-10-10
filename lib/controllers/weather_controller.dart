import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import '../models/weather_models.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/l10n.dart';
import '../utils/units.dart';
import '../utils/weather_palette.dart';

enum LoadStatus { loading, ready, error }

/// Ilovaning butun holati shu yerda: sozlamalar, tanlangan shahar, prognoz.
class WeatherController extends ChangeNotifier {
  WeatherController(
      this._storage, {
        WeatherService? service,
        LocationService? location,
      })  : _service = service ?? WeatherService(),
        _location = location ?? LocationService();

  final StorageService _storage;
  final WeatherService _service;
  final LocationService _location;

  AppLanguage language = AppLanguage.en;
  TempUnit tempUnit = TempUnit.celsius;
  WindUnit windUnit = WindUnit.ms;
  bool useGps = true;
  GeoPlace? place;
  List<GeoPlace> favorites = [];

  Forecast? forecast;
  LoadStatus status = LoadStatus.loading;

  /// Internet yo‘q, eski (saqlangan) ma’lumot ko‘rsatilmoqda
  bool offline = false;

  /// Hozir yangilanmoqda
  bool refreshing = false;

  LocationFailure? _locationIssue;
  int _requestId = 0;

  S get s => S(language);

  WeatherPalette get palette {
    final current = forecast?.current;
    return WeatherPalette.of(
      current?.kind ?? WeatherKind.clear,
      current?.isDay ?? true,
    );
  }

  /// Telefonda saqlangan hamma narsani o‘qiydi (tez, internet kerak emas).
  void loadLocal() {
    language = _storage.language ??
        AppLanguage.fromCode(ui.PlatformDispatcher.instance.locale.languageCode) ??
        AppLanguage.en;
    tempUnit = _storage.tempUnit;
    windUnit = _storage.windUnit;
    useGps = _storage.useGps;
    place = _storage.place;
    favorites = _storage.favorites;

    final cached = _storage.cachedForecast;
    if (cached != null) {
      forecast = cached;
      status = LoadStatus.ready;
    }
  }

  Future<void> start() => refresh();

  /// Prognozni yangilaydi. GPS yoqilgan bo‘lsa avval joylashuvni aniqlaydi.
  Future<void> refresh() async {
    final id = ++_requestId;
    refreshing = true;
    if (forecast == null) status = LoadStatus.loading;
    notifyListeners();

    try {
      var target = place ?? GeoPlace.tashkent;

      if (useGps) {
        try {
          final position = await _location.currentPosition();
          if (id != _requestId) return;
          target = await _service.reverseGeocode(
            position.latitude,
            position.longitude,
            language.code,
          );
          if (id != _requestId) return;
        } on LocationException catch (error) {
          if (id != _requestId) return;
          _locationIssue = error.failure;
          // Ruxsat yo‘q yoki GPS o‘chiq bo‘lsa, har safar so‘ramaymiz
          if (error.failure != LocationFailure.timeout &&
              error.failure != LocationFailure.unknown) {
            useGps = false;
            unawaited(_storage.setUseGps(false));
          }
        }
      }

      final raw = await _service.fetchForecast(target);
      if (id != _requestId) return;

      final fetchedAt = DateTime.now();
      forecast = Forecast.fromApi(raw, target, fetchedAt: fetchedAt);
      place = target;
      status = LoadStatus.ready;
      offline = false;

      unawaited(_storage.saveForecast(raw, target, fetchedAt));
      unawaited(_storage.setPlace(target));
    } catch (_) {
      if (id != _requestId) return;
      if (forecast != null) {
        offline = true;
        status = LoadStatus.ready;
      } else {
        status = LoadStatus.error;
      }
    } finally {
      if (id == _requestId) {
        refreshing = false;
        notifyListeners();
      }
    }
  }

  /// Ilova qayta ochilganda ma’lumot 15 daqiqadan eski bo‘lsa yangilaydi.
  void refreshIfStale() {
    if (refreshing) return;
    final current = forecast;
    if (current == null ||
        DateTime.now().difference(current.fetchedAt) >
            const Duration(minutes: 15)) {
      unawaited(refresh());
    }
  }

  Future<void> selectPlace(GeoPlace value) async {
    useGps = false;
    place = value;
    forecast = null;
    offline = false;
    status = LoadStatus.loading;
    unawaited(_storage.setUseGps(false));
    notifyListeners();
    await refresh();
  }

  Future<void> useMyLocation() async {
    useGps = true;
    unawaited(_storage.setUseGps(true));
    await refresh();
  }

  Future<List<GeoPlace>> search(String query) =>
      _service.searchCity(query, language.code);

  // ---- Saqlangan shaharlar ----
  bool isFavorite(GeoPlace value) => favorites.any((f) => f.sameAs(value));

  void toggleFavorite(GeoPlace value) {
    if (isFavorite(value)) {
      removeFavorite(value);
      return;
    }
    favorites = [...favorites, value.copyWith(isCurrent: false)];
    unawaited(_storage.setFavorites(favorites));
    notifyListeners();
  }

  void removeFavorite(GeoPlace value) {
    favorites = [
      for (final f in favorites)
        if (!f.sameAs(value)) f,
    ];
    unawaited(_storage.setFavorites(favorites));
    notifyListeners();
  }

  // ---- Sozlamalar ----
  void setLanguage(AppLanguage value) {
    language = value;
    unawaited(_storage.setLanguage(value));
    notifyListeners();
  }

  void setTempUnit(TempUnit value) {
    tempUnit = value;
    unawaited(_storage.setTempUnit(value));
    notifyListeners();
  }

  void setWindUnit(WindUnit value) {
    windUnit = value;
    unawaited(_storage.setWindUnit(value));
    notifyListeners();
  }

  // ---- Joylashuv xabarlari ----
  LocationFailure? takeLocationIssue() {
    final issue = _locationIssue;
    _locationIssue = null;
    return issue;
  }

  Future<void> openLocationSettings(LocationFailure failure) =>
      _location.openSettings(failure);
}