enum WeatherKind { sun, partly, cloud, rain, storm }

class HourWeather {
  final String time;
  final WeatherKind kind;
  final String rain;
  final String wind;

  const HourWeather(this.time, this.kind, this.rain, this.wind);
}

class DayWeather {
  final String name;
  final String rain;
  final String wind;
  final WeatherKind kind;
  final String temp;

  const DayWeather(this.name, this.rain, this.wind, this.kind, this.temp);
}