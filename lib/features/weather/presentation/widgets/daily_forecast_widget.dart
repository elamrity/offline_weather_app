import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<ForecastDayEntity> dailyForecast;

  const DailyForecastWidget({super.key, required this.dailyForecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('5-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyForecast.length,
          itemBuilder: (context, index) {
            final day = dailyForecast[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(day.dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(day.condition),
                trailing: Text(
                  '${day.maxTemp.round()}° / ${day.minTemp.round()}°C',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}