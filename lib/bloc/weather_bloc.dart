import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService _weatherService;
  final StorageService _storageService;

  WeatherBloc(this._weatherService, this._storageService) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<FetchWeatherByLocation>(_onFetchWeatherByLocation);
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<ClearRecentSearches>(_onClearRecentSearches);
  }

  Future<void> _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await _weatherService.getWeatherByCity(event.cityName);
      await _storageService.saveRecentSearch(weather);
      final recentSearches = _storageService.getRecentSearches();
      emit(WeatherLoaded(weather: weather, recentSearches: recentSearches));
    } catch (e) {
      final recentSearches = _storageService.getRecentSearches();
      emit(WeatherError(message: e.toString(), recentSearches: recentSearches));
    }
  }

  Future<void> _onFetchWeatherByLocation(FetchWeatherByLocation event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await _weatherService.getWeatherByCoordinates(event.latitude, event.longitude);
      await _storageService.saveRecentSearch(weather);
      final recentSearches = _storageService.getRecentSearches();
      emit(WeatherLoaded(weather: weather, recentSearches: recentSearches));
    } catch (e) {
      final recentSearches = _storageService.getRecentSearches();
      emit(WeatherError(message: e.toString(), recentSearches: recentSearches));
    }
  }

  Future<void> _onLoadRecentSearches(LoadRecentSearches event, Emitter<WeatherState> emit) async {
    final recentSearches = _storageService.getRecentSearches();
    emit(RecentSearchesLoaded(recentSearches));
  }

  Future<void> _onClearRecentSearches(ClearRecentSearches event, Emitter<WeatherState> emit) async {
    await _storageService.clearRecentSearches();
    emit(const RecentSearchesLoaded([]));
  }
}