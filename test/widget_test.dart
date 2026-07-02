import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:weather/features/weather/presentation/blocs/weather_state.dart';
import 'package:weather/features/weather/presentation/pages/weather_dashboard_page.dart';

// عمل Mock للـ Bloc
class MockWeatherBloc extends Mock implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  testWidgets('should display CircularProgressIndicator when state is WeatherLoading', (WidgetTester tester) async {
    // Arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());
    // أضف الـ stream لمنع الـ BlocBuilder من إخراج خطأ أثناء البناء
    when(() => mockWeatherBloc.stream).thenAnswer((_) => Stream.value(WeatherLoading()));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>.value(
          value: mockWeatherBloc,
          child: const WeatherDashboardPage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}