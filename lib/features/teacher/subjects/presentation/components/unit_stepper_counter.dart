import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class UnitStepperCounter extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const UnitStepperCounter({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        GestureDetector(
          onTap: onDecrement,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 52.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.remove,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.4),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'الوحده $value',
              style: AppStyles.font16Bold(context),
            ),
          ),
        ),
        10.horizontalSpace,
        GestureDetector(
          onTap: onIncrement,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 52.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
}
