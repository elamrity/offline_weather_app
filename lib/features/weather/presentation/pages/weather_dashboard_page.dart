import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/presentation/blocs/weather_event.dart';
import '../blocs/weather_bloc.dart';
import '../blocs/weather_state.dart';
import '../widgets/hourly_forecast_widget.dart';
import '../widgets/daily_forecast_widget.dart';
import 'location_selection_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeatherDashboardPage extends StatelessWidget {
  const WeatherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationSelectionPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            final weather = state.weather;
            final lastUpdatedStr = DateFormat('hh:mm a').format(weather.lastUpdated);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<WeatherBloc>().add(FetchWeatherEvent(weather.cityName));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                children: [
                  Card(
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            weather.cityName,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weather.temperature.round()}°C',
                            style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w300, color: Colors.white),
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(fontSize: 20, color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Last Updated: $lastUpdatedStr',
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // تم تعديل استدعاء الـ Widgets الخارجية المخصصة التي قمنا بفصلها لرفع الأداء
                  HourlyForecastWidget(hourlyForecast: weather.hourlyForecast),
                  const SizedBox(height: 24),

                  DailyForecastWidget(dailyForecast: weather.dailyForecast),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // نحاول إعادة جلب بيانات آخر مدينة تم البحث عنها بدلاً من فرض القاهرة دائماً
                        final settingsBox = Hive.box('settingsBox');
                        final lastCity = settingsBox.get('last_city', defaultValue: 'Cairo');
                        context.read<WeatherBloc>().add(FetchWeatherEvent(lastCity));
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Search for a city to start!'));
        },
      ),
    );
  }
}