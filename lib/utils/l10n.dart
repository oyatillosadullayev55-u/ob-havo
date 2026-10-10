import '../models/weather_models.dart';
import 'units.dart';

/// Ilova tillari
enum AppLanguage {
  uz('uz', 'O‘zbekcha'),
  en('en', 'English'),
  ru('ru', 'Русский');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  static AppLanguage? fromCode(String? code) {
    for (final language in AppLanguage.values) {
      if (language.code == code) return language;
    }
    return null;
  }
}

/// Barcha matnlar shu yerda (uz / en / ru).
class S {
  const S(this.lang);

  final AppLanguage lang;

  String _t(String uz, String en, String ru) => switch (lang) {
    AppLanguage.uz => uz,
    AppLanguage.en => en,
    AppLanguage.ru => ru,
  };

  // ---- Umumiy ----
  String get appName => _t('Ob-havo', 'Weather', 'Погода');
  String get now => _t('Hozir', 'Now', 'Сейчас');
  String get today => _t('Bugun', 'Today', 'Сегодня');
  String get more => _t('Ko‘proq', 'More', 'Ещё');
  String get less => _t('Kamroq', 'Less', 'Свернуть');
  String get retry => _t('Qayta urinish', 'Try again', 'Повторить');
  String get settings => _t('Sozlamalar', 'Settings', 'Настройки');

  // ---- Tafsilotlar ----
  String get feelsLike => _t('His qilinishi', 'Feels like', 'Ощущается');
  String get humidity => _t('Namlik', 'Humidity', 'Влажность');
  String get wind => _t('Shamol', 'Wind', 'Ветер');
  String get gusts => _t('shiddati', 'gusts', 'порывы');
  String get pressure => _t('Bosim', 'Pressure', 'Давление');
  String get pressureUnit => _t('hPa', 'hPa', 'гПа');
  String get uvIndex => _t('UV indeks', 'UV index', 'УФ-индекс');
  String get precipitation => _t('Yog‘in miqdori', 'Precipitation', 'Осадки');
  String get mm => _t('mm', 'mm', 'мм');
  String get sunrise => _t('Quyosh chiqishi', 'Sunrise', 'Восход');
  String get sunset => _t('Quyosh botishi', 'Sunset', 'Закат');
  String get chanceOfRain =>
      _t('Yog‘in ehtimoli', 'Chance of rain', 'Вероятность осадков');
  String get maxWind => _t('Maks. shamol', 'Max wind', 'Макс. ветер');

  // ---- Qidiruv va shaharlar ----
  String get searchHint =>
      _t('Shahar nomini yozing', 'Search for a city', 'Введите город');
  String get myLocation =>
      _t('Mening joylashuvim', 'My location', 'Моё местоположение');
  String get savedCities =>
      _t('Saqlangan shaharlar', 'Saved cities', 'Сохранённые города');
  String get noSavedCities => _t(
    'Shaharni qidiruvdagi yulduzcha bilan saqlang.',
    'Save a city with the star in search.',
    'Сохраняйте города звёздочкой в поиске.',
  );
  String get popularCities =>
      _t('Mashhur shaharlar', 'Popular cities', 'Популярные города');
  String get addCity => _t('Shahar qo‘shish', 'Add a city', 'Добавить город');
  String get noResults =>
      _t('Shahar topilmadi', 'No cities found', 'Город не найден');
  String get searchFailed => _t(
    'Qidirib bo‘lmadi. Internetni tekshiring.',
    'Search failed. Check your connection.',
    'Поиск не удался. Проверьте соединение.',
  );
  String get saveCity => _t('Saqlash', 'Save', 'Сохранить');
  String get removeCity => _t('O‘chirish', 'Remove', 'Удалить');

  // ---- Sozlamalar ----
  String get temperature => _t('Harorat', 'Temperature', 'Температура');
  String get windSpeed =>
      _t('Shamol tezligi', 'Wind speed', 'Скорость ветра');
  String get language => _t('Til', 'Language', 'Язык');
  String get dataBy => _t(
    'Ma’lumot manbasi: Open-Meteo.com',
    'Weather data by Open-Meteo.com',
    'Данные: Open-Meteo.com',
  );

  // ---- Xatolar ----
  String get errorTitle => _t(
    'Ob-havoni yuklab bo‘lmadi',
    'Couldn’t load the weather',
    'Не удалось загрузить погоду',
  );
  String get errorBody => _t(
    'Internetga ulanishni tekshirib, qayta urinib ko‘ring.',
    'Check your internet connection and try again.',
    'Проверьте подключение к интернету и повторите попытку.',
  );
  String get chooseAnotherCity => _t(
    'Boshqa shaharni tanlash',
    'Choose another city',
    'Выбрать другой город',
  );
  String offlineBanner(String time) => _t(
    'Oflayn rejim. Oxirgi yangilanish: $time',
    'Offline. Last updated at $time',
    'Нет сети. Обновлено в $time',
  );
  String get locationDenied => _t(
    'Joylashuvga ruxsat berilmadi. Shaharni qo‘lda tanlang.',
    'Location permission was denied. Pick a city manually.',
    'Нет доступа к местоположению. Выберите город вручную.',
  );
  String get locationDisabled => _t(
    'Joylashuv xizmati o‘chiq. GPS ni yoqing.',
    'Location services are off. Turn on GPS.',
    'Геолокация выключена. Включите GPS.',
  );
  String get locationFailed => _t(
    'Joylashuvni aniqlab bo‘lmadi.',
    'Couldn’t get your location.',
    'Не удалось определить местоположение.',
  );

  // ---- Ob-havo holatlari ----
  String condition(WeatherKind kind) => switch (kind) {
    WeatherKind.clear => _t('Ochiq', 'Clear', 'Ясно'),
    WeatherKind.partly =>
        _t('Qisman bulutli', 'Partly cloudy', 'Переменная облачность'),
    WeatherKind.cloudy => _t('Bulutli', 'Cloudy', 'Облачно'),
    WeatherKind.fog => _t('Tuman', 'Fog', 'Туман'),
    WeatherKind.drizzle => _t('Mayda yomg‘ir', 'Drizzle', 'Морось'),
    WeatherKind.rain => _t('Yomg‘ir', 'Rain', 'Дождь'),
    WeatherKind.snow => _t('Qor', 'Snow', 'Снег'),
    WeatherKind.storm => _t('Momaqaldiroq', 'Thunderstorm', 'Гроза'),
  };

  String uvLabel(double uv) {
    if (uv < 3) return _t('Past', 'Low', 'Низкий');
    if (uv < 6) return _t('O‘rtacha', 'Moderate', 'Умеренный');
    if (uv < 8) return _t('Yuqori', 'High', 'Высокий');
    if (uv < 11) return _t('Juda yuqori', 'Very high', 'Очень высокий');
    return _t('Xavfli', 'Extreme', 'Экстремальный');
  }

  // ---- Birliklar ----
  String windUnitLabel(WindUnit unit) => switch (unit) {
    WindUnit.ms => _t('m/s', 'm/s', 'м/с'),
    WindUnit.kmh => _t('km/h', 'km/h', 'км/ч'),
    WindUnit.mph => _t('mph', 'mph', 'миль/ч'),
  };

  String windText(double metersPerSecond, WindUnit unit) =>
      '${Units.wind(metersPerSecond, unit).round()} ${windUnitLabel(unit)}';

  // ---- Sana va vaqt ----
  static const _weekdaysShort = <AppLanguage, List<String>>{
    AppLanguage.uz: ['Dush', 'Sesh', 'Chor', 'Pay', 'Juma', 'Shan', 'Yak'],
    AppLanguage.en: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    AppLanguage.ru: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
  };

  static const _weekdaysFull = <AppLanguage, List<String>>{
    AppLanguage.uz: [
      'Dushanba',
      'Seshanba',
      'Chorshanba',
      'Payshanba',
      'Juma',
      'Shanba',
      'Yakshanba',
    ],
    AppLanguage.en: [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    AppLanguage.ru: [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ],
  };

  static const _monthsShort = <AppLanguage, List<String>>{
    AppLanguage.uz: [
      'yan', 'fev', 'mar', 'apr', 'may', 'iyun', //
      'iyul', 'avg', 'sen', 'okt', 'noy', 'dek',
    ],
    AppLanguage.en: [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ],
    AppLanguage.ru: [
      'янв', 'фев', 'мар', 'апр', 'мая', 'июн', //
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ],
  };

  static const _compass = <AppLanguage, List<String>>{
    AppLanguage.uz: ['Sh', 'ShQ', 'Q', 'JQ', 'J', 'JG‘', 'G‘', 'ShG‘'],
    AppLanguage.en: ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'],
    AppLanguage.ru: ['С', 'СВ', 'В', 'ЮВ', 'Ю', 'ЮЗ', 'З', 'СЗ'],
  };

  String weekdayShort(int weekday) => _weekdaysShort[lang]![weekday - 1];
  String weekdayFull(int weekday) => _weekdaysFull[lang]![weekday - 1];
  String monthShort(int month) => _monthsShort[lang]![month - 1];

  String compass(int degrees) {
    final index = ((degrees % 360) / 45).round() % 8;
    return _compass[lang]![index];
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  String clock(DateTime time) => '${_two(time.hour)}:${_two(time.minute)}';

  String monthDay(DateTime date) => lang == AppLanguage.en
      ? '${monthShort(date.month)} ${date.day}'
      : '${date.day} ${monthShort(date.month)}';

  /// Masalan: "Wed, May 26, 15:00"
  String dateTime(DateTime time) =>
      '${weekdayShort(time.weekday)}, ${monthDay(time)}, ${clock(time)}';
}