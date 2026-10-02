import '../models/weather_models.dart';

const hours = [
  HourWeather('Now', WeatherKind.sun, '14%', '4 m/s'),
  HourWeather('16:00', WeatherKind.partly, '37%', '7 m/s'),
  HourWeather('17:00', WeatherKind.sun, '23%', '4 m/s'),
  HourWeather('18:00', WeatherKind.cloud, '45%', '6 m/s'),
  HourWeather('19:00', WeatherKind.rain, '75%', '7 m/s'),
];

const days = [
  DayWeather('Today', '45%', '7 m/s', WeatherKind.partly, '29°/16°'),
  DayWeather('Thu', '7%', '3 m/s', WeatherKind.sun, '31°/19°'),
  DayWeather('Fri', '15%', '5 m/s', WeatherKind.partly, '28°/15°'),
  DayWeather('Sat', '44%', '2 m/s', WeatherKind.cloud, '26°/15°'),
  DayWeather('Sun', '87%', '8 m/s', WeatherKind.rain, '23°/14°'),
  DayWeather('Mon', '89%', '6 m/s', WeatherKind.storm, '22°/13°'),
];