import 'package:flutter/material.dart';
import '../../base/safe_cubit.dart';
import '../../caching/shared_pref_service.dart';
import '../../constants/app_constants.dart';
import 'theme_state.dart';

class ThemeCubit extends SafeCubit<ThemeState> {
  final SharedPrefService _sharedPrefService;

  ThemeCubit(this._sharedPrefService) : super(_getInitialState(_sharedPrefService));

  static ThemeState _getInitialState(SharedPrefService service) {
    final isDarkSaved = service.getBool(AppConstants.isDarkModeKey);
    if (isDarkSaved == null) {
      final isPlatformDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
      return ThemeInitialState(
        themeMode: ThemeMode.system,
        isDark: isPlatformDark,
      );
    }
    return ThemeInitialState(
      themeMode: isDarkSaved ? ThemeMode.dark : ThemeMode.light,
      isDark: isDarkSaved,
    );
  }

  bool get isDarkMode => state.isDark;

  Future<void> toggleTheme() async {
    final nextIsDark = !state.isDark;
    final nextMode = nextIsDark ? ThemeMode.dark : ThemeMode.light;
    await _sharedPrefService.setBool(AppConstants.isDarkModeKey, nextIsDark);
    emit(
      ThemeChangedState(
        themeMode: nextMode,
        isDark: nextIsDark,
      ),
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    final bool nextIsDark;
    if (mode == ThemeMode.system) {
      await _sharedPrefService.remove(AppConstants.isDarkModeKey);
      nextIsDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    } else {
      nextIsDark = mode == ThemeMode.dark;
      await _sharedPrefService.setBool(AppConstants.isDarkModeKey, nextIsDark);
    }
    emit(
      ThemeChangedState(
        themeMode: mode,
        isDark: nextIsDark,
      ),
    );
  }
}
