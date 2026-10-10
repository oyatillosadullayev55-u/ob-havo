/// Ob-havo holati turlari (WMO kodlaridan olinadi)
enum WeatherKind { clear, partly, cloudy, fog, drizzle, rain, snow, storm }

WeatherKind kindFromCode(int code) {
  if (code == 0 || code == 1) return WeatherKind.clear;
  if (code == 2) return WeatherKind.partly;
  if (code == 3) return WeatherKind.cloudy;
  if (code == 45 || code == 48) return WeatherKind.fog;
  if (code >= 51 && code <= 57) return WeatherKind.drizzle;
  if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
    return WeatherKind.rain;
  }
  if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
    return WeatherKind.snow;
  }
  if (code >= 95) return WeatherKind.storm;
  return WeatherKind.cloudy;
}

// ---- JSON yordamchilari (null bo‘lsa ham yiqilmaydi) ----

/// Server vaqtni shaharning o‘z vaqti bilan beradi ("2026-10-09T14:00").
/// Uni UTC deb o‘qiymiz, shunda soat/kun maydonlari aynan shahar vaqtini ko‘rsatadi.
DateTime _parseTime(String value) {
  var text = value;
  if (text.length == 10) text = '${text}T00:00';
  return DateTime.parse('${text}Z');
}

DateTime? _parseTimeOrNull(dynamic value) =>
    value is String && value.isNotEmpty ? _parseTime(value) : null;

double _num(dynamic value, [double fallback = 0]) =>
    value is num ? value.toDouble() : fallback;

double? _numOrNull(dynamic value) => value is num ? value.toDouble() : null;

int? _intOrNull(dynamic value) => value is num ? value.round() : null;

List<dynamic> _list(dynamic value) => value is List ? value : const <dynamic>[];

dynamic _at(List<dynamic> list, int index) =>
    index < list.length ? list[index] : null;

/// Shahar yoki joylashuv
class GeoPlace {
  const GeoPlace({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.region = '',
    this.isCurrent = false,
  });

  /// GPS ishlamasa va hech narsa tanlanmagan bo‘lsa shu shahar ko‘rsatiladi
  static const tashkent = GeoPlace(
    name: 'Tashkent',
    country: 'Uzbekistan',
    latitude: 41.3111,
    longitude: 69.2797,
  );

  final String name;
  final String country;
  final String region;
  final double latitude;
  final double longitude;

  /// GPS orqali aniqlangan joymi
  final bool isCurrent;

  String title(String fallback) {
    if (name.isEmpty) return fallback;
    return country.isEmpty ? name : '$name, $country';
  }

  String get subtitle =>
      [region, country].where((part) => part.isNotEmpty).join(', ');

  bool sameAs(GeoPlace other) =>
      (latitude - other.latitude).abs() < 0.02 &&
          (longitude - other.longitude).abs() < 0.02;

  GeoPlace copyWith({bool? isCurrent}) => GeoPlace(
    name: name,
    country: country,
    region: region,
    latitude: latitude,
    longitude: longitude,
    isCurrent: isCurrent ?? this.isCurrent,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'country': country,
    'region': region,
    'latitude': latitude,
    'longitude': longitude,
    'isCurrent': isCurrent,
  };

  factory GeoPlace.fromJson(Map<String, dynamic> json) => GeoPlace(
    name: json['name'] as String? ?? '',
    country: json['country'] as String? ?? '',
    region: json['region'] as String? ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    isCurrent: json['isCurrent'] as bool? ?? false,
  );

  /// Open-Meteo geocoding javobidan
  factory GeoPlace.fromGeocoding(Map<String, dynamic> json) => GeoPlace(
    name: json['name'] as String? ?? '',
    country: json['country'] as String? ?? '',
    region: json['admin1'] as String? ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

/// Hozirgi ob-havo
class CurrentConditions {
  const CurrentConditions({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
    required this.precipitation,
    required this.code,
    required this.isDay,
  });

  final DateTime time;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final double windGusts;
  final int windDirection;
  final double precipitation;
  final int code;
  final bool isDay;

  WeatherKind get kind => kindFromCode(code);
}

/// Bir soatlik prognoz
class HourWeather {
  const HourWeather({
    required this.time,
    required this.temperature,
    required this.precipProb,
    required this.windSpeed,
    required this.code,
    required this.isDay,
  });

  final DateTime time;
  final double temperature;
  final int? precipProb;
  final double windSpeed;
  final int code;
  final bool isDay;

  WeatherKind get kind => kindFromCode(code);
}

/// Bir kunlik prognoz
class DayWeather {
  const DayWeather({
    required this.date,
    required this.code,
    required this.tempMax,
    required this.tempMin,
    required this.precipProb,
    required this.precipSum,
    required this.windMax,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
  });

  final DateTime date;
  final int code;
  final double tempMax;
  final double tempMin;
  final int? precipProb;
  final double precipSum;
  final double windMax;
  final double? uvIndex;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherKind get kind => kindFromCode(code);
}

/// Serverdan kelgan to‘liq prognoz
class Forecast {
  const Forecast({
    required this.place,
    required this.current,
    required this.hours,
    required this.days,
    required this.fetchedAt,
  });

  final GeoPlace place;
  final CurrentConditions current;
  final List<HourWeather> hours;
  final List<DayWeather> days;
  final DateTime fetchedAt;

  factory Forecast.fromApi(
      Map<String, dynamic> json,
      GeoPlace place, {
        DateTime? fetchedAt,
      }) {
    final cur = json['current'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final current = CurrentConditions(
      time: _parseTime(cur['time'] as String),
      temperature: _num(cur['temperature_2m']),
      feelsLike: _num(cur['apparent_temperature'], _num(cur['temperature_2m'])),
      humidity: _intOrNull(cur['relative_humidity_2m']) ?? 0,
      pressure: _num(cur['pressure_msl']),
      windSpeed: _num(cur['wind_speed_10m']),
      windGusts: _num(cur['wind_gusts_10m']),
      windDirection: _intOrNull(cur['wind_direction_10m']) ?? 0,
      precipitation: _num(cur['precipitation']),
      code: _intOrNull(cur['weather_code']) ?? 0,
      isDay: _intOrNull(cur['is_day']) != 0,
    );

    // Soatlik prognoz
    final hTime = _list(hourly['time']);
    final hTemp = _list(hourly['temperature_2m']);
    final hProb = _list(hourly['precipitation_probability']);
    final hCode = _list(hourly['weather_code']);
    final hWind = _list(hourly['wind_speed_10m']);
    final hDay = _list(hourly['is_day']);

    final allHours = <HourWeather>[
      for (var i = 0; i < hTime.length; i++)
        HourWeather(
          time: _parseTime(hTime[i] as String),
          temperature: _num(_at(hTemp, i)),
          precipProb: _intOrNull(_at(hProb, i)),
          windSpeed: _num(_at(hWind, i)),
          code: _intOrNull(_at(hCode, i)) ?? 0,
          isDay: _intOrNull(_at(hDay, i)) != 0,
        ),
    ];

    // Hozirgi soatdan boshlab 24 soat
    final nowHour = DateTime.utc(
      current.time.year,
      current.time.month,
      current.time.day,
      current.time.hour,
    );
    var start = allHours.indexWhere((h) => !h.time.isBefore(nowHour));
    if (start < 0) start = 0;
    final hours = allHours.skip(start).take(24).toList();
    if (hours.isNotEmpty) {
      final first = hours.first;
      hours[0] = HourWeather(
        time: first.time,
        temperature: current.temperature,
        precipProb: first.precipProb,
        windSpeed: current.windSpeed,
        code: current.code,
        isDay: current.isDay,
      );
    }

    // Kunlik prognoz
    final dTime = _list(daily['time']);
    final dCode = _list(daily['weather_code']);
    final dMax = _list(daily['temperature_2m_max']);
    final dMin = _list(daily['temperature_2m_min']);
    final dProb = _list(daily['precipitation_probability_max']);
    final dRain = _list(daily['precipitation_sum']);
    final dWind = _list(daily['wind_speed_10m_max']);
    final dUv = _list(daily['uv_index_max']);
    final dRise = _list(daily['sunrise']);
    final dSet = _list(daily['sunset']);

    final days = <DayWeather>[
      for (var i = 0; i < dTime.length; i++)
        DayWeather(
          date: _parseTime(dTime[i] as String),
          code: _intOrNull(_at(dCode, i)) ?? 0,
          tempMax: _num(_at(dMax, i)),
          tempMin: _num(_at(dMin, i)),
          precipProb: _intOrNull(_at(dProb, i)),
          precipSum: _num(_at(dRain, i)),
          windMax: _num(_at(dWind, i)),
          uvIndex: _numOrNull(_at(dUv, i)),
          sunrise: _parseTimeOrNull(_at(dRise, i)),
          sunset: _parseTimeOrNull(_at(dSet, i)),
        ),
    ];

    if (days.isEmpty) {
      throw const FormatException('Prognoz bo‘sh keldi');
    }

    return Forecast(
      place: place,
      current: current,
      hours: hours,
      days: days,
      fetchedAt: fetchedAt ?? DateTime.now(),
    );
  }
}