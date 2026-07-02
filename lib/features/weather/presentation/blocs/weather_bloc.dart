import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_weather_usecase.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;

  WeatherBloc({required this.getWeatherUseCase}) : super(WeatherInitial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(WeatherLoading());

      final result = await getWeatherUseCase(event.cityName);

      result.fold(
            (failure) => emit(WeatherError(failure.message)),
            (weatherData) => emit(WeatherLoaded(weatherData)),
      );
    });
  }
}