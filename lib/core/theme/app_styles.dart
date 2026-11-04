import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_font_weight.dart';

class AppStyles {
  AppStyles._();

  static const String fontFamily = 'Tajawal';

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

  static TextStyle font16BoldPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primary,
  );
}

