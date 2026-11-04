import 'package:flutter/material.dart';
import '../../base/safe_cubit.dart';
import '../../caching/shared_pref_service.dart';
import '../../constants/app_constants.dart';

class ThemeCubit extends SafeCubit<ThemeMode> {
  final SharedPrefService _sharedPrefService;

  ThemeCubit(this._sharedPrefService) : super(_getInitialTheme(_sharedPrefService));

  static ThemeMode _getInitialTheme(SharedPrefService service) {
    final isDark = service.getBool(AppConstants.isDarkModeKey);
    if (isDark == null) {
      return ThemeMode.system;
    }
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  void toggleTheme() {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _sharedPrefService.setBool(AppConstants.isDarkModeKey, nextMode == ThemeMode.dark);
    emit(nextMode);
  }

  void setTheme(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      _sharedPrefService.remove(AppConstants.isDarkModeKey);
    } else {
      _sharedPrefService.setBool(AppConstants.isDarkModeKey, mode == ThemeMode.dark);
    }
    emit(mode);
  }
}

