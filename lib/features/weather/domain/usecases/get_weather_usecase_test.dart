import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/features/weather/domain/entities/weather_entity.dart';
import 'package:weather/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather/features/weather/domain/usecases/get_weather_usecase.dart';

// عمل Mock للمستودع باستخدام Mocktail
class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherUseCase useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherUseCase(mockRepository);
  });

  const tCityName = 'Cairo';
  final tWeatherEntity = WeatherEntity(
    cityName: 'Cairo',
    temperature: 25.0,
    condition: 'Sunny',
    icon: '//cdn.weatherapi.com/dark.png',
    humidity: 50,
    windSpeed: 15.0,
    hourlyForecast: const [],
    dailyForecast: const [],
    lastUpdated: DateTime.now(),
  );

  test(
    'should get weather info for the city from the repository',
        () async {
      // Arrange (إعداد التوقعات الموك)
      when(() => mockRepository.getWeather(any()))
          .thenAnswer((_) async => Right(tWeatherEntity));

      // Act (استدعاء الـ UseCase الفعلي)
      final result = await useCase(tCityName);

      // Assert (التأكد من النتيجة)
      expect(result, Right(tWeatherEntity));
      verify(() => mockRepository.getWeather(tCityName)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}