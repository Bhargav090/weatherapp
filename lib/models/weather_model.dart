import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final double feelsLike;
  final int pressure;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.feelsLike,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'main': condition,
          'description': description,
          'icon': iconCode,
        }
      ],
      'wind': {'speed': windSpeed},
      'visibility': visibility,
      'sys': {
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      }
    };
  }

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    condition,
    description,
    humidity,
    windSpeed,
    iconCode,
    feelsLike,
    pressure,
    visibility,
    sunrise,
    sunset,
  ];
}
