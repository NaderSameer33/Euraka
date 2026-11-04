import 'package:flutter/material.dart';
import '../extension/spacing_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_loading.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 56.h;
    final effectiveWidth = width ?? double.infinity;
    final effectiveRadius = borderRadius ?? 8.r;
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final isInteractive = onPressed != null && !isLoading;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isInteractive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? AppLoading(
                size: 24.r,
                color: AppColors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    8.horizontalSpace,
                  ],
                  Text(
                    text,
                    style: textStyle ?? AppStyles.font18BoldWhite,
                  ),
                  if (suffixIcon != null) ...[
                    8.horizontalSpace,
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
