import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../bloc/theme_bloc.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  const DetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;
    final isNight = DateTime.now().hour >= 18 || DateTime.now().hour <= 6;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(weather.temperature, weather.condition, isNight),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, size),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildWeatherHero(context, isNight, size),
                      SizedBox(height: size.height * 0.04),
                      _buildWeatherCards(context, isDarkMode, size),
                      SizedBox(height: size.height * 0.03),
                      _buildSunMoonCard(context, isDarkMode, size),
                      SizedBox(height: size.height * 0.03),
                      _buildAdditionalInfo(context, isDarkMode, size),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(double temperature, String condition, bool isNight) {
    final conditionLower = condition.toLowerCase();
    
    // Night time backgrounds
    if (isNight) {
      if (conditionLower.contains('clear') || conditionLower.contains('sun')) {
        return [
          const Color(0xFF0F0F23), // Deep night blue
          const Color(0xFF1A1A2E), 
          const Color(0xFF16213E)
        ];
      } else if (conditionLower.contains('rain') || conditionLower.contains('storm')) {
        return [
          const Color(0xFF1C1C3A), // Stormy night
          const Color(0xFF2D2D4A),
          const Color(0xFF3E3E5C)
        ];
      } else if (conditionLower.contains('cloud')) {
        return [
          const Color(0xFF2C2C54), // Cloudy night
          const Color(0xFF3A3A6B),
          const Color(0xFF4A4A7C)
        ];
      } else if (conditionLower.contains('snow')) {
        return [
          const Color(0xFF2A2A4A), // Snowy night
          const Color(0xFF3C3C5C),
          const Color(0xFF4E4E6E)
        ];
      }
    }
    
    // Daytime backgrounds based on temperature and condition
    if (temperature >= 35) {
      // Very hot - desert/heat wave colors
      return [
        const Color(0xFFFF6B35), // Hot orange
        const Color(0xFFFF8E53),
        const Color(0xFFFFB07A)
      ];
    } else if (temperature >= 25 && temperature < 35) {
      // Warm weather
      if (conditionLower.contains('clear') || conditionLower.contains('sun')) {
        return [
          const Color(0xFF4A90E2), // Bright sunny blue
          const Color(0xFF5BA3F5),
          const Color(0xFF6CB6FF)
        ];
      } else if (conditionLower.contains('cloud')) {
        return [
          const Color(0xFF6C9BD1), // Warm cloudy
          const Color(0xFF7DAEE4),
          const Color(0xFF8EC1F7)
        ];
      }
    } else if (temperature >= 15 && temperature < 25) {
      // Mild weather
      if (conditionLower.contains('clear') || conditionLower.contains('sun')) {
        return [
          const Color(0xFF3F7CAC), // Mild sunny
          const Color(0xFF5095C5),
          const Color(0xFF61AEDE)
        ];
      } else if (conditionLower.contains('rain')) {
        return [
          const Color(0xFF4B79A1), // Rainy mild
          const Color(0xFF5C8AB4),
          const Color(0xFF6D9BC7)
        ];
      } else if (conditionLower.contains('cloud')) {
        return [
          const Color(0xFF6B8CAE), // Cloudy mild
          const Color(0xFF7C9DC1),
          const Color(0xFF8DAED4)
        ];
      }
    } else if (temperature >= 5 && temperature < 15) {
      // Cool weather
      if (conditionLower.contains('clear') || conditionLower.contains('sun')) {
        return [
          const Color(0xFF2E5BBA), // Cool sunny
          const Color(0xFF3F6CCB),
          const Color(0xFF507DDC)
        ];
      } else if (conditionLower.contains('rain')) {
        return [
          const Color(0xFF4A6B8A), // Cool rainy
          const Color(0xFF5B7C9B),
          const Color(0xFF6C8DAC)
        ];
      } else if (conditionLower.contains('cloud')) {
        return [
          const Color(0xFF5C7A99), // Cool cloudy
          const Color(0xFF6D8BAA),
          const Color(0xFF7E9CBB)
        ];
      }
    } else if (temperature >= -5 && temperature < 5) {
      // Cold weather
      if (conditionLower.contains('snow')) {
        return [
          const Color(0xFF8EC5FC), // Snowy cold
          const Color(0xFFB8D4FC),
          const Color(0xFFE2E3FD)
        ];
      } else {
        return [
          const Color(0xFF1E3A8A), // Cold blue
          const Color(0xFF2F4B9B),
          const Color(0xFF405CAC)
        ];
      }
    } else {
      // Very cold (below -5°C)
      if (conditionLower.contains('snow')) {
        return [
          const Color(0xFFADD8E6), // Icy snow
          const Color(0xFFCDE7F0),
          const Color(0xFFEDF6FA)
        ];
      } else {
        return [
          const Color(0xFF0F3460), // Very cold
          const Color(0xFF204571),
          const Color(0xFF315682)
        ];
      }
    }
    
    // Default fallback based on condition
    if (conditionLower.contains('rain') || conditionLower.contains('storm')) {
      return [
        const Color(0xFF4A6741), // Rainy green-gray
        const Color(0xFF5B7852),
        const Color(0xFF6C8963)
      ];
    } else if (conditionLower.contains('cloud')) {
      return [
        const Color(0xFF6C757D), // Cloudy gray
        const Color(0xFF7D868E),
        const Color(0xFF8E979F)
      ];
    }
    
    // Ultimate fallback
    return [
      const Color(0xFF4A90E2),
      const Color(0xFF2E5BBA),
      const Color(0xFF1E3A8A)
    ];
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Row(
        children: [
          Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: size.width * 0.05,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Text(
            DateFormat('EEEE, MMM d').format(DateTime.now()),
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHero(BuildContext context, bool isNight, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.04,
      ),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: TextStyle(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.02),
          _buildWeatherIcon(isNight, size),
          SizedBox(height: size.height * 0.03),
          FittedBox(
            child: Text(
              '${weather.temperature.round()}°',
              style: TextStyle(
                fontSize: size.width * 0.25,
                fontWeight: FontWeight.w100,
                color: Colors.white,
                height: 0.8,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            weather.condition,
            style: TextStyle(
              fontSize: size.width * 0.045,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(bool isNight, Size size) {
    final condition = weather.condition.toLowerCase();
    final temp = weather.temperature;
    
    IconData iconData;
    List<Color> colors;
    
    if (condition.contains('sun') || condition.contains('clear')) {
      iconData = isNight ? Icons.nightlight_round : Icons.wb_sunny;
      if (isNight) {
        colors = [const Color(0xFFE6E6FA), const Color(0xFFD3D3D3)];
      } else {
        // Temperature-based sun colors
        if (temp >= 35) {
          colors = [const Color(0xFFFF4500), const Color(0xFFFF6347)]; // Hot sun
        } else if (temp >= 25) {
          colors = [const Color(0xFFFFD700), const Color(0xFFFF8C00)]; // Warm sun
        } else {
          colors = [const Color(0xFFFFE135), const Color(0xFFFFB347)]; // Mild sun
        }
      }
    } else if (condition.contains('rain') || condition.contains('storm')) {
      iconData = condition.contains('storm') ? Icons.thunderstorm : Icons.water_drop;
      if (temp <= 5) {
        colors = [const Color(0xFF4682B4), const Color(0xFF5F9EA0)]; // Cold rain
      } else {
        colors = [const Color(0xFF64B5F6), const Color(0xFF42A5F5)]; // Normal rain
      }
    } else if (condition.contains('snow')) {
      iconData = Icons.ac_unit;
      colors = [const Color(0xFFFFFFFF), const Color(0xFFE6F3FF)]; // Snow
    } else if (condition.contains('cloud')) {
      iconData = Icons.cloud;
      if (temp >= 25) {
        colors = [const Color(0xFFD3D3D3), const Color(0xFFA9A9A9)]; // Warm clouds
      } else if (temp <= 5) {
        colors = [const Color(0xFFB0C4DE), const Color(0xFF87CEEB)]; // Cold clouds
      } else {
        colors = [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)]; // Normal clouds
      }
    } else {
      iconData = Icons.wb_cloudy;
      colors = [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)];
    }

    final iconSize = size.width * 0.3;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            blurRadius: size.width * 0.05,
            spreadRadius: size.width * 0.0125,
          ),
        ],
      ),
      child: Icon(iconData, color: Colors.white, size: iconSize * 0.5),
    );
  }

  Widget _buildWeatherCards(BuildContext context, bool isDarkMode, Size size) {
    final metrics = [
      {'icon': Icons.water_drop, 'label': 'Humidity', 'value': '${weather.humidity}%'},
      {'icon': Icons.air, 'label': 'Wind', 'value': '${weather.windSpeed} m/s'},
      {'icon': Icons.compress, 'label': 'Pressure', 'value': '${weather.pressure} hPa'},
      {'icon': Icons.visibility, 'label': 'Visibility', 'value': '${(weather.visibility / 1000).toStringAsFixed(1)} km'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: size.width * 0.04,
          mainAxisSpacing: size.width * 0.04,
          childAspectRatio: 1.3,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return _buildMetricCard(
            metric['icon'] as IconData,
            metric['label'] as String,
            metric['value'] as String,
            isDarkMode,
            size,
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value, bool isDarkMode, Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: size.width * 0.02,
            offset: Offset(0, size.height * 0.005),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: size.width * 0.06),
          SizedBox(height: size.height * 0.01),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: size.width * 0.03,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunMoonCard(BuildContext context, bool isDarkMode, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSunMoonTime(
              Icons.wb_sunny,
              'Sunrise',
              DateFormat('HH:mm').format(weather.sunrise),
              size,
            ),
          ),
          Container(
            width: 1,
            height: size.height * 0.05,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildSunMoonTime(
              Icons.nightlight_round,
              'Sunset',
              DateFormat('HH:mm').format(weather.sunset),
              size,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunMoonTime(IconData icon, String label, String time, Size size) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: size.width * 0.07),
        SizedBox(height: size.height * 0.01),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: size.width * 0.03,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: size.height * 0.005),
        Text(
          time,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, bool isDarkMode, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            weather.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}