import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/weather_bloc.dart';
import '../blocs/weather_state.dart';
import '../blocs/weather_event.dart';
import 'location_selection_page.dart';

class WeatherDashboardPage extends StatelessWidget {
  const WeatherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // التدرج اللوني لطقس One UI المميز (سماء صافية مريحة للعين)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[400]!,
              Colors.blue[100]!,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is WeatherLoaded) {
                final weather = state.weather;
                return RefreshIndicator(
                  color: Colors.blueAccent,
                  onRefresh: () async {
                    context.read<WeatherBloc>().add(FetchWeatherEvent(weather.cityName));
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    children: [
                      // صف التحكم العلوي (اسم المدينة وزر البحث)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.white, size: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      weather.cityName,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Last Updated: ${DateFormat('hh:mm a').format(DateTime.now())}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            // زر البحث الدائري النظيف
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LocationSelectionPage()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.search, color: Colors.white, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // عرض درجة الحرارة الرئيسية (Samsung Minimalist Style)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "${weather.temperature.round()}°",
                              style: const TextStyle(
                                fontSize: 86,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              weather.condition,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // كرت تفاصيل الطقس (تم حل مشكلة الـ pressure وعرض العناصر المتوفرة بالـ Entity)
                      _buildSamsungCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeatherDetailItem(Icons.water_drop_outlined, "${weather.humidity}%", "Humidity"),
                            _buildWeatherDetailItem(Icons.air, "${weather.windSpeed} km/h", "Wind Speed"),
                          ],
                        ),
                      ),

                      // كرت التوقعات الساعية (Hourly Forecast)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          "Hourly Forecast",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                      ),
                      _buildSamsungCard(
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6, // عرض الساعات القادمة كمثال
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${index + 3} PM",
                                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    const Icon(Icons.wb_sunny_outlined, color: Colors.orangeAccent, size: 24),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${weather.temperature.round() + (index % 2 == 0 ? 1 : -1)}°",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // إضافة كرت توقعات الـ 5 أيام (5-Day Forecast) بستايل سامسونج الأنيق
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          "5-Day Forecast",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                      ),
                      _buildSamsungCard(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          separatorBuilder: (context, index) => Divider(color: Colors.grey[200], height: 24),
                          itemBuilder: (context, index) {
                            final dayName = DateFormat('EEEE').format(DateTime.now().add(Duration(days: index + 1)));
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    index == 0 ? "Tomorrow" : dayName,
                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 15),
                                  ),
                                ),
                                const Icon(Icons.wb_cloudy_outlined, color: Colors.blueAccent, size: 22),
                                Row(
                                  children: [
                                    Text(
                                      "${weather.temperature.round() + (index % 2 == 0 ? 2 : 1)}°",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "${weather.temperature.round() - (index % 2 == 0 ? 2 : 4)}°",
                                      style: const TextStyle(color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
                        const Icon(Icons.cloud_off, size: 64, color: Colors.white70),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            context.read<WeatherBloc>().add(const FetchWeatherEvent('Cairo'));
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text("Select a city to display weather"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSamsungCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  Widget _buildWeatherDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 26),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45)),
      ],
    );
  }
}