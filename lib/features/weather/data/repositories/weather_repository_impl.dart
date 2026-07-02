import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// استخدام الـ Package Imports لمنع أي تعارض في المسارات
import 'package:weather/core/error/failures.dart';
import 'package:weather/features/weather/domain/entities/weather_entity.dart';
import 'package:weather/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather/features/weather/data/datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final Connectivity connectivity;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName) async {
    // 1. التحقق من حالة الاتصال بالإنترنت
    final connectivityResult = await connectivity.checkConnectivity();
    final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

    if (hasInternet) {
      try {
        // 2. إذا وجد إنترنت، جلب البيانات من السيرفر
        final remoteWeather = await remoteDataSource.getRemoteWeather(cityName);

        // 3. تحديث الكاش المحلي بالبيانات الجديدة
        await localDataSource.cacheWeather(remoteWeather);

        return Right(remoteWeather);
      } catch (e) {
        // إذا حدث خطأ غير متوقع في السيرفر، نحاول الإنقاذ بالجلب من الكاش
        try {
          final localWeather = await localDataSource.getLastWeather();
          return Right(localWeather);
        } catch (_) {
          // تم الإصلاح هنا بإضافة Left
          return const Left(ServerFailure("Failed to fetch data from server."));
        }
      }
    } else {
      // 4. إذا كان أوفلاين، جلب البيانات مباشرة من الكاش المحلي
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } catch (e) {
        // تم الإصلاح هنا بإضافة Left
        return const Left(CacheFailure("No internet connection and no cached data found."));
      }
    }
  }
}