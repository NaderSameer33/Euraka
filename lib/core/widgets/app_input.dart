import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/spacing_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final String? labelText;
  final bool isObscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final bool enabled;
  final FocusNode? focusNode;
  final Color? fillColor;
  final double? borderRadius;

  const AppInput({
    super.key,
    this.controller,
    this.title,
    this.hintText,
    this.labelText,
    this.isObscure = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.enabled = true,
    this.focusNode,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultFillColor = isDark ? AppColors.inputFillDark : AppColors.inputFillLight;
    final defaultBorderColor = theme.colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.6);
    final radius = BorderRadius.circular(borderRadius ?? 10.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppStyles.font14Medium(context),
          ),
          8.verticalSpace,
        ],
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: maxLines,
          enabled: enabled,
          focusNode: focusNode,
          style: AppStyles.font16Regular(context),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.font14Regular(context),
            labelText: labelText,
            labelStyle: AppStyles.font14Regular(context),
            filled: true,
            fillColor: fillColor ?? defaultFillColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            errorStyle: TextStyle(
              fontFamily: AppStyles.fontFamily,
              fontSize: 12.sp,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: defaultBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: defaultBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
