import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_colors.dart';

class HelperMethod {
  HelperMethod._();

  static void showSuccessToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: autoCloseDuration,
      primaryColor: AppColors.success,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: autoCloseDuration,
      primaryColor: AppColors.error,
    );
  }

  static void showWarningToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: autoCloseDuration,
      primaryColor: AppColors.warning,
    );
  }

  static void showInfoToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: autoCloseDuration,
      primaryColor: AppColors.info,
    );
  }
}
