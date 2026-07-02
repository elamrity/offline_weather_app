import 'package:dio/dio.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getRemoteWeather(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  // ال API Key المجاني من موقع weatherapi.com
  final String apiKey = 'd7949d5aa9964a35ba7103955260207';

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getRemoteWeather(String cityName) async {
    final response = await dio.get(
      'https://api.weatherapi.com/v1/forecast.json',
      queryParameters: {
        'key': apiKey,
        'q': cityName,
        'days': 5, // جلب توقعات لـ 5 أيام كما هو مطلوب في الـ Daily Forecast
        'aqi': 'no',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}