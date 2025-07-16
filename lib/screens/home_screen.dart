import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/bloc/theme_event.dart';
import 'package:weatherapp/bloc/weather_event.dart';
import 'package:weatherapp/bloc/weather_state.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../widgets/weather_card.dart';
import '../widgets/recent_searches.dart';
import '../widgets/loading_shimmer.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadInitialWeather();
  }

  Future<void> _loadInitialWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled----
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle location services disabled----
      context.read<WeatherBloc>().add(LoadRecentSearches());
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle permission denied
        context.read<WeatherBloc>().add(LoadRecentSearches());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permission permanently denied
      context.read<WeatherBloc>().add(LoadRecentSearches());
      return;
    }

    // Get current position and fetch weather
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      context.read<WeatherBloc>().add(FetchWeatherByLocation(position.latitude, position.longitude));
    } catch (e) {
      context.read<WeatherBloc>().add(LoadRecentSearches());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    if (_controller.text.trim().isNotEmpty) {
      context.read<WeatherBloc>().add(FetchWeather(_controller.text.trim()));
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;
    final size = MediaQuery.of(context).size;
    final baseFontSize = size.width * 0.04;
    final basePadding = size.width * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              basePadding,
              basePadding,
              basePadding,
              basePadding + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather App',
                          style: TextStyle(
                            fontSize: baseFontSize * 1.4,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM dd').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: baseFontSize * 0.8,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<ThemeBloc>().add(ToggleTheme());
                      },
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.yellow : Colors.grey[700],
                        size: baseFontSize * 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: basePadding),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(basePadding * 0.75),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
                        blurRadius: basePadding * 0.625,
                        offset: Offset(0, basePadding * 0.3125),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _searchWeather(),
                    decoration: InputDecoration(
                      hintText: 'Search for a city...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: baseFontSize * 0.8,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[500],
                        size: baseFontSize * 1.1,
                      ),
                      suffixIcon: IconButton(
                        onPressed: _searchWeather,
                        icon: Container(
                          padding: EdgeInsets.all(basePadding * 0.5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(basePadding * 0.625),
                          ),


                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: baseFontSize,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: basePadding,
                        vertical: basePadding,
                      ),
                    ),
                    style: TextStyle(fontSize: baseFontSize * 0.8),
                  ),
                ),
                SizedBox(height: basePadding),

                // Weather Content
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return const LoadingShimmer();
                    } else if (state is WeatherLoaded) {
                      _animationController.forward();
                      return Column(
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: WeatherCard(
                              weather: state.weather,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(weather: state.weather),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: basePadding),
                          if (state.recentSearches.isNotEmpty)
                            RecentSearches(
                              recentSearches: state.recentSearches,
                              onClear: () {
                                context.read<WeatherBloc>().add(ClearRecentSearches());
                              },
                              onSearchTap: (weather) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(weather: weather),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    } else if (state is WeatherError) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(basePadding * 1.25),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(basePadding * 0.9375),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: baseFontSize * 2.4,
                                ),
                                SizedBox(height: basePadding * 0.75),
                                Text(
                                  'Oops!',
                                  style: TextStyle(
                                    fontSize: baseFontSize * 0.9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: basePadding * 0.5),
                                Text(
                                  state.message.replaceAll('Exception: ', ''),
                                  style: TextStyle(
                                    fontSize: baseFontSize * 0.7,
                                    color: Colors.red[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: basePadding),
                          if (state.recentSearches.isNotEmpty)
                            RecentSearches(
                              recentSearches: state.recentSearches,
                              onClear: () {
                                context.read<WeatherBloc>().add(ClearRecentSearches());
                              },
                              onSearchTap: (weather) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(weather: weather),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    } else if (state is RecentSearchesLoaded) {
                      return state.recentSearches.isNotEmpty
                          ? RecentSearches(
                              recentSearches: state.recentSearches,
                              onClear: () {
                                context.read<WeatherBloc>().add(ClearRecentSearches());
                              },
                              onSearchTap: (weather) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(weather: weather),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    size: baseFontSize * 4,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: basePadding),
                                  Text(
                                    'Welcome to Weather App!',
                                    style: TextStyle(
                                      fontSize: baseFontSize * 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: basePadding * 0.5),
                                  Text(
                                    'Search for a city to get started',
                                    style: TextStyle(
                                      fontSize: baseFontSize * 0.8,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}