import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import '../services/storage_service.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc(this._storageService) : super(const ThemeState(isDarkMode: false)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDarkMode = _storageService.getDarkMode();
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = !state.isDarkMode;
    await _storageService.saveDarkMode(newTheme);
    emit(ThemeState(isDarkMode: newTheme));
  }
}
