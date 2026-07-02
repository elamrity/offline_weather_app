import 'package:hive/hive.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherToCache);
  Future<WeatherModel> getLastWeather();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final String cachedWeatherKey = 'CACHED_WEATHER';
  final String boxName = 'weatherBox';

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) async {
    final box = await Hive.openBox(boxName);
    // نقوم بحفظ البيانات بداخل الـ Box باستخدام المفتاح الثابت
    await box.put(cachedWeatherKey, weatherToCache);
  }

  @override
  Future<WeatherModel> getLastWeather() async {
    final box = await Hive.openBox(boxName);
    final cachedData = box.get(cachedWeatherKey);

    if (cachedData != null) {
      return cachedData as WeatherModel;
    } else {
      throw Exception("No data cached locally");
    }
  }
}