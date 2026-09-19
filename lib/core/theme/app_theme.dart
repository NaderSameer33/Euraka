import 'package:euraka/core/constants/app_constants.dart';
import 'package:euraka/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  // ☀️ الثيم الفاتح (Light Theme)
  static ThemeData lightTheme = ThemeData(
    fontFamily: AppConstants.fontFamity,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // اللون الأساسي للتطبيق
      onPrimary:
          AppColors.white, // لون النص/الأيقونة المرسومة فوق اللون الأساسي
      secondary: AppColors.blue, // لون ثانوي للتمييز (Accent)
      onSecondary: AppColors.white, // لون النص فوق اللون الثانوي
      surface: AppColors.white, // لون خلفية الكروت والقوائم (Card/Dialog)
      onSurface: AppColors.neutral900, // لون النصوص العامة فوق الـ surface
      error: AppColors.red, // لون رسائل الخطأ والتنبيهات
      onError: AppColors.white, // لون النص داخل رسائل الخطأ
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  // 🌙 الثيم الداكن (Dark Theme)
  static ThemeData darkTheme = ThemeData(
    fontFamily: AppConstants.fontFamity,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors
          .primaryLight, // في الوضع المظلم نستخدم درجة أفتح قليلاً لتكون مريحة للعين
      onPrimary: AppColors.neutral900, // لون النص فوق الـ primary
      secondary: AppColors.blue, // اللون الثانوي
      onSecondary: AppColors.white, // لون النص فوق اللون الثانوي
      surface: AppColors.dark, // لون خلفية الكروت في الوضع الداكن
      onSurface:
          AppColors.white, // لون النصوص العامة (أبيض ليظهر على الخلفية الداكنة)
      error: AppColors.red, // لون الخطأ
      onError: AppColors.white, // لون النص داخل الخطأ
    ),
  );
}
