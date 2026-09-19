import 'package:euraka/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {

  static ThemeData lightTheme = ThemeData(
  
    scaffoldBackgroundColor: AppColors.white,
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark,
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
      ),
    ),
  );
}
