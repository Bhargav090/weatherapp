import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = '68693f812d0133b150a4dfc366e36ac2';

  Future<Weather> getWeatherByCity(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('City not found: $cityName');
      } else {
        debugPrint('City API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('City weather fetch error: $e');
      throw Exception('Error fetching weather for $cityName: $e');
    }
  }

  Future<Weather> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Location not found for coordinates: ($latitude, $longitude)');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded');
      } else {
        debugPrint('Coordinates API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather for location: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Coordinates weather fetch error: $e');
      throw Exception('Error fetching weather for location ($latitude, $longitude): $e');
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}