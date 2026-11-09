import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_font_weight.dart';

class AppStyles {
  AppStyles._();

  static const String fontFamily = 'Tajawal';

  static TextStyle font34Bold(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 34.sp,
      fontWeight: AppFontWeight.bold,
      color: isDark ? AppColors.white : AppColors.primary,
      letterSpacing: 1.2,
    );
  }

  static TextStyle font24Bold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.sp,
      fontWeight: AppFontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font20Bold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.sp,
      fontWeight: AppFontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font18Bold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.sp,
      fontWeight: AppFontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font18Medium(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.sp,
      fontWeight: AppFontWeight.medium,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font18Regular(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.sp,
      fontWeight: AppFontWeight.regular,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle font16Bold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: AppFontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font16Medium(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: AppFontWeight.medium,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font16Regular(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: AppFontWeight.regular,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font14Bold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font14Medium(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.medium,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font14Regular(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.regular,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle font14RegularMuted(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: AppFontWeight.regular,
      color: AppColors.textMutedLight,
    );
  }

  static TextStyle font13Medium(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 13.sp,
      fontWeight: AppFontWeight.medium,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font13Regular(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 13.sp,
      fontWeight: AppFontWeight.regular,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle font11SemiBold(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 11.sp,
      fontWeight: AppFontWeight.semiBold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font13MediumLetterSpacing(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 13.sp,
      fontWeight: AppFontWeight.medium,
      color: isDark ? AppColors.textSecondaryDark : AppColors.primaryDark,
      letterSpacing: 4.0,
    );
  }

  static TextStyle font12Medium(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: AppFontWeight.medium,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle font12Regular(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: AppFontWeight.regular,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle font18BoldWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: AppFontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle font16BoldWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle font14MediumPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeight.medium,
    color: AppColors.primary,
  );

  static TextStyle font12MediumPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeight.medium,
    color: AppColors.primary,
  );

  static TextStyle font12MediumError = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeight.medium,
    color: AppColors.error,
  );

  static TextStyle font16BoldPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primary,
  );
}
