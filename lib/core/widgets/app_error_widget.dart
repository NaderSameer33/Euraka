import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/spacing_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  icon ?? Icons.error_outline_rounded,
                  size: 36.sp,
                  color: colorScheme.error,
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              title ?? 'حدث خطأ ما',
              style: AppStyles.font18Bold(context),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              message,
              style: AppStyles.font14Regular(context),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              20.verticalSpace,
              AppButton(
                text: retryText ?? 'إعادة المحاولة',
                onPressed: onRetry,
                width: 160.w,
                height: 44.h,
                borderRadius: 12.r,
                textStyle: AppStyles.font14Medium(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: Icon(
                  Icons.refresh_rounded,
                  size: 18.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
