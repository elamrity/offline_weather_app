import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Package imports بتمنع أي لخبطة في المسارات
import 'package:weather/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather/features/weather/presentation/blocs/weather_bloc.dart';

final sl = GetIt.instance; // sl تعني Service Locator

Future<void> initDependencies() async {
  //! Features - Weather

  // Use cases
  // أضف هذا السطر داخل دالة initDependencies() في البداية:
  sl.registerFactory(() => WeatherBloc(getWeatherUseCase: sl()));
  sl.registerLazySingleton(() => GetWeatherUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectivity: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
        () => WeatherRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
        () => WeatherLocalDataSourceImpl(),
  );

  //! Core / External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}