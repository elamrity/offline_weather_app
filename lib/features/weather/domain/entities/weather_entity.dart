import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final List<ForecastHourEntity> hourlyForecast;
  final List<ForecastDayEntity> dailyForecast;
  final DateTime lastUpdated;

  const WeatherEntity({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [cityName, temperature, condition, lastUpdated];
}

class ForecastHourEntity extends Equatable {
  final String time;
  final double temperature;
  final String icon;

  const ForecastHourEntity({required this.time, required this.temperature, required this.icon});

  @override
  List<Object?> get props => [time, temperature, icon];
}

class ForecastDayEntity extends Equatable {
  final String dayName;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;

  const ForecastDayEntity({
    required this.dayName,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  });

  @override
  List<Object?> get props => [dayName, maxTemp, minTemp, condition, icon];
}