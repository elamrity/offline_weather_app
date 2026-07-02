import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../blocs/weather_bloc.dart';
import '../blocs/weather_event.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final TextEditingController _controller = TextEditingController();

  void _searchCity() async {
    final cityName = _controller.text.trim();
    if (cityName.isNotEmpty) {
      // 1. إرسال حدث جلب طقس المدينة الجديدة للـ BLoC
      context.read<WeatherBloc>().add(FetchWeatherEvent(cityName));

      // 2. حفظ اسم المدينة في الكاش لتصبح هي الافتراضية عند فتح التطبيق مجدداً
      final settingsBox = Hive.box('settingsBox');
      await settingsBox.put('last_city', cityName);

      // 3. العودة للشاشة السابقة (Dashboard)
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                hintText: 'e.g., London, Alexandria, New York',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchCity,
                ),
              ),
              onSubmitted: (_) => _searchCity(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Searching for a new city will automatically update your dashboard and cache it for offline use.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}