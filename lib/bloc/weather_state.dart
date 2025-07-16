import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<Weather> recentSearches;

  const WeatherLoaded({
    required this.weather,
    required this.recentSearches,
  });

  @override
  List<Object> get props => [weather, recentSearches];
}

class WeatherError extends WeatherState {
  final String message;
  final List<Weather> recentSearches;

  const WeatherError({
    required this.message,
    required this.recentSearches,
  });

  @override
  List<Object> get props => [message, recentSearches];
}

class RecentSearchesLoaded extends WeatherState {
  final List<Weather> recentSearches;

  const RecentSearchesLoaded(this.recentSearches);

  @override
  List<Object> get props => [recentSearches];
}
