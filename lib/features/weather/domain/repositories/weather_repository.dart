import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart'; // سننشئه بعد قليل
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  // نمرر اسم المدينة كـ Parameter، ونعيد إما Failure (فشل) أو WeatherEntity (نجاح)
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName);
}