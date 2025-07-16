import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/bloc/theme_event.dart';
import 'package:weatherapp/bloc/theme_state.dart';
import 'screens/home_screen.dart';
import 'bloc/weather_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'services/weather_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  final weatherService = WeatherService();
  
  runApp(MyApp(
    storageService: storageService,
    weatherService: weatherService,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final WeatherService weatherService;

  const MyApp({
    super.key,
    required this.storageService,
    required this.weatherService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(storageService)..add(LoadTheme()),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(weatherService, storageService),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            ),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
