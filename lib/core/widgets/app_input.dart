import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/spacing_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AppInput extends FormField<String> {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final String? labelText;
  final bool isObscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final double? borderRadius;

  AppInput({
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
    super.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    super.enabled = true,
    this.focusNode,
    this.fillColor,
    this.borderRadius,
  }) : super(
         initialValue: controller?.text ?? '',
         builder: (FormFieldState<String> field) {
           final context = field.context;
           final theme = Theme.of(context);
           final isDark = theme.brightness == Brightness.dark;
           final defaultFillColor = isDark
               ? AppColors.inputFillDark
               : AppColors.inputFillLight;
           final defaultBorderColor = theme.colorScheme.outline.withValues(
             alpha: isDark ? 0.35 : 0.6,
           );
           final radius = BorderRadius.circular(borderRadius ?? 10.r);
           final hasError = field.hasError;

           Widget? effectiveSuffixIcon;
           final errorIcon = Padding(
             padding: EdgeInsets.symmetric(horizontal: 10.w),
             child: Icon(
               Icons.error,
               color: AppColors.error,
               size: 20.sp,
             ),
           );

           if (hasError && suffixIcon != null) {
             effectiveSuffixIcon = Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 suffixIcon,
                 errorIcon,
               ],
             );
           } else if (hasError) {
             effectiveSuffixIcon = errorIcon;
           } else {
             effectiveSuffixIcon = suffixIcon;
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               if (title != null) ...[
                 Text(
                   title,
                   style: AppStyles.font14Medium(context),
                 ),
                 8.verticalSpace,
               ],
               TextFormField(
                 controller: controller,
                 obscureText: isObscure,
                 keyboardType: keyboardType,
                 textInputAction: textInputAction,
                 onChanged: (val) {
                   field.didChange(val);
                   onChanged?.call(val);
                 },
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
                   suffixIcon: effectiveSuffixIcon,
                   contentPadding: EdgeInsets.symmetric(
                     horizontal: 16.w,
                     vertical: 16.h,
                   ),
                   errorStyle: const TextStyle(
                     fontSize: 0,
                     height: 0,
                   ),
                   border: OutlineInputBorder(
                     borderRadius: radius,
                     borderSide: BorderSide(
                       color: hasError ? AppColors.error : defaultBorderColor,
                       width: hasError ? 1.5 : 1.0,
                     ),
                   ),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: radius,
                     borderSide: BorderSide(
                       color: hasError ? AppColors.error : defaultBorderColor,
                       width: hasError ? 1.5 : 1.0,
                     ),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: radius,
                     borderSide: BorderSide(
                       color: hasError ? AppColors.error : AppColors.primary,
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
               if (hasError) ...[
                 6.verticalSpace,
                 Row(
                   children: [
                     Icon(
                       Icons.error,
                       color: AppColors.error,
                       size: 14.sp,
                     ),
                     6.horizontalSpace,
                     Expanded(
                       child: Text(
                         field.errorText ?? '',
                         style: TextStyle(
                           fontFamily: AppStyles.fontFamily,
                           fontSize: 12.sp,
                           color: AppColors.error,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   ],
                 ),
               ],
             ],
           );
         },
       );
}
