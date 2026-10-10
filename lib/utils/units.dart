/// Harorat va shamol birliklari.
/// Server doim °C va m/s qaytaradi, birlikni almashtirish ilovaning
/// o‘zida hisoblanadi (qayta yuklash shart emas).
enum TempUnit { celsius, fahrenheit }

enum WindUnit { ms, kmh, mph }

class Units {
  Units._();

  static double temp(double celsius, TempUnit unit) =>
      unit == TempUnit.celsius ? celsius : celsius * 9 / 5 + 32;

  static String tempText(double celsius, TempUnit unit) =>
      '${temp(celsius, unit).round()}°';

  static double wind(double metersPerSecond, WindUnit unit) => switch (unit) {
    WindUnit.ms => metersPerSecond,
    WindUnit.kmh => metersPerSecond * 3.6,
    WindUnit.mph => metersPerSecond * 2.236936,
  };
}