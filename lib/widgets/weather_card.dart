import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/weather_model.dart';
import '../bloc/theme_bloc.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback onTap;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [Colors.blue[400]!, Colors.blue[600]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.blue.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.condition,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Image.network(
                        WeatherService().getWeatherIconUrl(weather.iconCode),
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.wb_sunny, size: 60, color: Colors.white),
                      ),
                      Text(
                        '${weather.temperature.round()}°C',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(Icons.water_drop, 'Humidity', '${weather.humidity}%'),
                  _buildWeatherDetail(Icons.air, 'Wind', '${weather.windSpeed} m/s'),
                  _buildWeatherDetail(Icons.thermostat, 'Feels Like', '${weather.feelsLike.round()}°C'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'Tap for more details',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
