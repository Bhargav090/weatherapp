import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  final SharedPreferences _prefs;
  static const String _recentSearchesKey = 'recent_searches';
  static const String _darkModeKey = 'dark_mode';

  StorageService(this._prefs);

  Future<void> saveRecentSearch(Weather weather) async {
    List<String> searches = _prefs.getStringList(_recentSearchesKey) ?? [];
    
    // Remove if already exists
    searches.removeWhere((search) {
      final weatherData = Weather.fromJson(json.decode(search));
      return weatherData.cityName.toLowerCase() == weather.cityName.toLowerCase();
    });
    
    // Add to beginning
    searches.insert(0, json.encode(weather.toJson()));
    
    // Keep only last 10 searches
    if (searches.length > 10) {
      searches = searches.sublist(0, 10);
    }
    
    await _prefs.setStringList(_recentSearchesKey, searches);
  }

  List<Weather> getRecentSearches() {
    List<String> searches = _prefs.getStringList(_recentSearchesKey) ?? [];
    return searches.map((search) => Weather.fromJson(json.decode(search))).toList();
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }

  Future<void> saveDarkMode(bool isDarkMode) async {
    await _prefs.setBool(_darkModeKey, isDarkMode);
  }

  bool getDarkMode() {
    return _prefs.getBool(_darkModeKey) ?? false;
  }
}
