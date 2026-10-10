import '../models/weather_models.dart';
import '../utils/l10n.dart';

class _Country {
  const _Country(this.uz, this.en, this.ru);

  final String uz;
  final String en;
  final String ru;

  String of(AppLanguage lang) => switch (lang) {
    AppLanguage.uz => uz,
    AppLanguage.en => en,
    AppLanguage.ru => ru,
  };
}

class _City {
  const _City(
      this.uz,
      this.en,
      this.ru,
      this.latitude,
      this.longitude,
      this.countryCode,
      );

  final String uz;
  final String en;
  final String ru;
  final double latitude;
  final double longitude;
  final String countryCode;

  String of(AppLanguage lang) => switch (lang) {
    AppLanguage.uz => uz,
    AppLanguage.en => en,
    AppLanguage.ru => ru,
  };
}

const _countries = <String, _Country>{
  'UZ': _Country('O‘zbekiston', 'Uzbekistan', 'Узбекистан'),
  'RU': _Country('Rossiya', 'Russia', 'Россия'),
  'KZ': _Country('Qozog‘iston', 'Kazakhstan', 'Казахстан'),
  'TR': _Country('Turkiya', 'Turkey', 'Турция'),
  'AE': _Country('BAA', 'UAE', 'ОАЭ'),
  'GB': _Country('Buyuk Britaniya', 'United Kingdom', 'Великобритания'),
  'US': _Country('AQSH', 'United States', 'США'),
  'KR': _Country('Janubiy Koreya', 'South Korea', 'Южная Корея'),
  'JP': _Country('Yaponiya', 'Japan', 'Япония'),
};

const _cities = <_City>[
  _City('Toshkent', 'Tashkent', 'Ташкент', 41.3111, 69.2797, 'UZ'),
  _City('Samarqand', 'Samarkand', 'Самарканд', 39.6542, 66.9597, 'UZ'),
  _City('Buxoro', 'Bukhara', 'Бухара', 39.7747, 64.4286, 'UZ'),
  _City('Namangan', 'Namangan', 'Наманган', 40.9983, 71.6726, 'UZ'),
  _City('Andijon', 'Andijan', 'Андижан', 40.7821, 72.3442, 'UZ'),
  _City('Farg‘ona', 'Fergana', 'Фергана', 40.3842, 71.7843, 'UZ'),
  _City('Nukus', 'Nukus', 'Нукус', 42.4531, 59.6103, 'UZ'),
  _City('Urganch', 'Urgench', 'Ургенч', 41.5500, 60.6333, 'UZ'),
  _City('Qarshi', 'Karshi', 'Карши', 38.8606, 65.7891, 'UZ'),
  _City('Termiz', 'Termez', 'Термез', 37.2242, 67.2783, 'UZ'),
  _City('Jizzax', 'Jizzakh', 'Джизак', 40.1158, 67.8422, 'UZ'),
  _City('Navoiy', 'Navoi', 'Навои', 40.0844, 65.3792, 'UZ'),
  _City('Guliston', 'Gulistan', 'Гулистан', 40.4897, 68.7842, 'UZ'),
  _City('Xiva', 'Khiva', 'Хива', 41.3783, 60.3639, 'UZ'),
  _City('Moskva', 'Moscow', 'Москва', 55.7558, 37.6173, 'RU'),
  _City('Olmaota', 'Almaty', 'Алматы', 43.2220, 76.8512, 'KZ'),
  _City('Istanbul', 'Istanbul', 'Стамбул', 41.0082, 28.9784, 'TR'),
  _City('Dubay', 'Dubai', 'Дубай', 25.2048, 55.2708, 'AE'),
  _City('London', 'London', 'Лондон', 51.5074, -0.1278, 'GB'),
  _City('Nyu-York', 'New York', 'Нью-Йорк', 40.7128, -74.0060, 'US'),
  _City('Seul', 'Seoul', 'Сеул', 37.5665, 126.9780, 'KR'),
  _City('Tokio', 'Tokyo', 'Токио', 35.6762, 139.6503, 'JP'),
];

/// Qidiruv oynasida ko‘rsatiladigan mashhur shaharlar (tanlangan tilda).
List<GeoPlace> popularCities(AppLanguage lang) {
  return [
    for (final city in _cities)
      GeoPlace(
        name: city.of(lang),
        country: _countries[city.countryCode]?.of(lang) ?? '',
        latitude: city.latitude,
        longitude: city.longitude,
      ),
  ];
}