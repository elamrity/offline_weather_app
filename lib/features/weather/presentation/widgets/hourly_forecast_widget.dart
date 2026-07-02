import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<ForecastHourEntity> hourlyForecast;

  const HourlyForecastWidget({super.key, required this.hourlyForecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hourly Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecast.length,
            itemBuilder: (context, index) {
              final hour = hourlyForecast[index];
              return Card(
                margin: const EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hour.time.contains(' ') ? hour.time.split(' ')[1] : hour.time),
                      const SizedBox(height: 8),
                      Text('${hour.temperature.round()}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}