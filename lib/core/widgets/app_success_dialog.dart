import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/spacing_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_button.dart';

class AppSuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const AppSuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.inputFillDark : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            16.verticalSpace,
            Text(
              title,
              style: AppStyles.font16Bold(context),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              subtitle,
              style: AppStyles.font12Regular(context),
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            AppButton(
              text: buttonText,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
