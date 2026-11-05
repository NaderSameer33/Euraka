import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class PasswordRequirementsCard extends StatelessWidget {
  final bool isLengthValid;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PasswordRequirementsCard({
    super.key,
    required this.isLengthValid,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
              8.horizontalSpace,
              Text(
                'نصائح لانشاء كلمه مرور قويه',
                style: AppStyles.font12MediumPrimary,
              ),
            ],
          ),
          8.verticalSpace,
          _buildItem(context, '8 أحرف على الأقل', isLengthValid),
          4.verticalSpace,
          _buildItem(context, 'يحتوي على رقم', hasNumber),
          4.verticalSpace,
          _buildItem(context, 'يحتوي على رمز خاص', hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String text, bool isValid) {
    final theme = Theme.of(context);
    final color = isValid ? AppColors.primary : theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: color,
          size: 14.sp,
        ),
        8.horizontalSpace,
        Text(
          text,
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            fontSize: 12.sp,
            color: color,
          ),
        ),
      ],
    );
  }
}

