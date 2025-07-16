import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String cityName;

  const FetchWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchWeatherByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;

  const FetchWeatherByLocation(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class LoadRecentSearches extends WeatherEvent {}

class ClearRecentSearches extends WeatherEvent {}