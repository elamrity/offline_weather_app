import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call(String cityName) async {
    return await repository.getWeather(cityName);
  }
}