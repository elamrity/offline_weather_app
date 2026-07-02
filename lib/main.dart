import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/core/di/injection_container.dart';
import 'package:weather/features/weather/data/models/weather_model.dart';
import 'package:weather/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:weather/features/weather/presentation/blocs/weather_event.dart';
import 'package:weather/features/weather/presentation/pages/weather_dashboard_page.dart';

void main() async {
  // التأكد من تهيئة كل الـ Bindings الخاصة بـ Flutter قبل أي كود يعمل Async
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة Hive وتجسيل الـ Adapters
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());
  Hive.registerAdapter(ForecastHourModelAdapter());
  Hive.registerAdapter(ForecastDayModelAdapter());

  // 2. تهيئة الـ Dependency Injection (GetIt)
  await initDependencies();

  // 3. فتح Box الإعدادات لجلب آخر مدينة بحث عنها المستخدم أو استخدام القاهرة كافتراضي
  final settingsBox = await Hive.openBox('settingsBox');
  final defaultCity = settingsBox.get('last_city', defaultValue: 'Cairo');

  runApp(MyApp(defaultCity: defaultCity));
}

class MyApp extends StatelessWidget {
  final String defaultCity;
  const MyApp({super.key, required this.defaultCity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // تمرير المدينة المسترجعة من الكاش ديناميكياً بدلاً من القيمة الثابتة
      create: (context) => sl<WeatherBloc>()..add(FetchWeatherEvent(defaultCity)),
      child: MaterialApp(
        title: 'Offline-First Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const WeatherDashboardPage(),
      ),
    );
  }
}