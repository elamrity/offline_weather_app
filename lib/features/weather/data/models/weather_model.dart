import 'package:hive/hive.dart';
import '../../domain/entities/weather_entity.dart';

part 'weather_model.g.dart'; // هذا السطر لتوليد الـ Adapter لاحقاً

@HiveType(typeId: 0)
class WeatherModel extends WeatherEntity {
  @HiveField(0)
  @override
  final String cityName;

  @HiveField(1)
  @override
  final double temperature;

  @HiveField(2)
  @override
  final String condition;

  @HiveField(3)
  @override
  final String icon;

  @HiveField(4)
  @override
  final int humidity;

  @HiveField(5)
  @override
  final double windSpeed;

  @HiveField(6)
  @override
  final List<ForecastHourModel> hourlyForecast;

  @HiveField(7)
  @override
  final List<ForecastDayModel> dailyForecast;

  @HiveField(8)
  @override
  final DateTime lastUpdated;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.lastUpdated,
  }) : super(
    cityName: cityName,
    temperature: temperature,
    condition: condition,
    icon: icon,
    humidity: humidity,
    windSpeed: windSpeed,
    hourlyForecast: hourlyForecast,
    dailyForecast: dailyForecast,
    lastUpdated: lastUpdated,
  );

  // عمل الـ parsing من الـ API (سنعتمد على هيكلة قريبة من OpenWeatherMap أو WeatherAPI)
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'] ?? '',
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'] ?? '',
      icon: json['current']['condition']['icon'] ?? '',
      humidity: json['current']['humidity'] ?? 0,
      windSpeed: (json['current']['wind_kph'] as num).toDouble(),
      hourlyForecast: (json['forecast']['forecastday'][0]['hour'] as List)
          .map((e) => ForecastHourModel.fromJson(e))
          .toList(),
      dailyForecast: (json['forecast']['forecastday'] as List)
          .map((e) => ForecastDayModel.fromJson(e))
          .toList(),
      lastUpdated: DateTime.now(), // نخزن وقت جلب البيانات الفعلي للكاش
    );
  }
}

@HiveType(typeId: 1)
class ForecastHourModel extends ForecastHourEntity {
  @HiveField(0)
  @override
  final String time;

  @HiveField(1)
  @override
  final double temperature;

  @HiveField(2)
  @override
  final String icon;

  const ForecastHourModel({
    required this.time,
    required this.temperature,
    required this.icon,
  }) : super(time: time, temperature: temperature, icon: icon);

  factory ForecastHourModel.fromJson(Map<String, dynamic> json) {
    return ForecastHourModel(
      time: json['time'] ?? '',
      temperature: (json['temp_c'] as num).toDouble(),
      icon: json['condition']['icon'] ?? '',
    );
  }
}

@HiveType(typeId: 2)
class ForecastDayModel extends ForecastDayEntity {
  @HiveField(0)
  @override
  final String dayName;

  @HiveField(1)
  @override
  final double maxTemp;

  @HiveField(2)
  @override
  final double minTemp;

  @HiveField(3)
  @override
  final String condition;

  @HiveField(4)
  @override
  final String icon;

  const ForecastDayModel({
    required this.dayName,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  }) : super(
    dayName: dayName,
    maxTemp: maxTemp,
    minTemp: minTemp,
    condition: condition,
    icon: icon,
  );

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      dayName: json['date'] ?? '',
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'] ?? '',
      icon: json['day']['condition']['icon'] ?? '',
    );
  }
}