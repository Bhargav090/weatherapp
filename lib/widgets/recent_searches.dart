import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/weather_model.dart';
import '../bloc/theme_bloc.dart';
import '../services/weather_service.dart';

class RecentSearches extends StatelessWidget {
  final List<Weather> recentSearches;
  final VoidCallback onClear;
  final Function(Weather) onSearchTap;

  const RecentSearches({
    super.key,
    required this.recentSearches,
    required this.onClear,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            TextButton(
              onPressed: onClear,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final weather = recentSearches[index];
              return GestureDetector(
                onTap: () => onSearchTap(weather),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          WeatherService().getWeatherIconUrl(weather.iconCode),
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.wb_sunny, size: 40, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.cityName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${weather.temperature.round()}°C',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
