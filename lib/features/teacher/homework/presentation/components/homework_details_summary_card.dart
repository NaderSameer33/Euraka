import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class HomeworkDetailsSummaryCard extends StatelessWidget {
  final int completedCount;
  final int pendingCount;
  final int remainingDays;

  const HomeworkDetailsSummaryCard({
    super.key,
    required this.completedCount,
    required this.pendingCount,
    required this.remainingDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Text(
            'ملخص النتيجه',
            style: AppStyles.font14Regular(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context: context,
                iconWidget: Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 20.r,
                ),
                iconBgColor: AppColors.primary.withValues(alpha: 0.15),
                number: '$completedCount',
                numberColor: AppColors.primary,
                label: 'أكملوا الحل',
              ),
              Container(
                width: 1.w,
                height: 56.h,
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
              _buildStatItem(
                context: context,
                iconWidget: Container(
                  width: 12.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                iconBgColor: const Color(0xFFFFB300).withValues(alpha: 0.15),
                number: '$pendingCount',
                numberColor: const Color(0xFFFFB300),
                label: 'لم يحلو بعد',
              ),
              Container(
                width: 1.w,
                height: 56.h,
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
              _buildStatItem(
                context: context,
                iconWidget: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.redAccent,
                  size: 16.r,
                ),
                iconBgColor: Colors.redAccent.withValues(alpha: 0.15),
                number: '$remainingDays',
                numberColor: Colors.redAccent,
                label: 'يوم متبقي',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required Widget iconWidget,
    required Color iconBgColor,
    required String number,
    required Color numberColor,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          8.verticalSpace,
          Text(
            number,
            style: AppStyles.font24Bold(context).copyWith(
              color: numberColor,
              height: 1.1,
            ),
          ),
          4.verticalSpace,
          Text(
            label,
            style: AppStyles.font12Regular(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

