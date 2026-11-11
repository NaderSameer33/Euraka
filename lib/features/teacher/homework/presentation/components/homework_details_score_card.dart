import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class HomeworkDetailsScoreCard extends StatelessWidget {
  final int highestScore;
  final int totalScore;

  const HomeworkDetailsScoreCard({
    super.key,
    required this.highestScore,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxScore = totalScore > 0 ? totalScore : 100;
    final displayScore = highestScore > 0 ? highestScore : 85;
    final ratio = (displayScore / maxScore).clamp(0.0, 1.0);

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
            'اعلى درجه تم الحصول عليها',
            style: AppStyles.font14Regular(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$displayScore',
                style: AppStyles.font34Bold(context).copyWith(
                  color: AppColors.primary,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '/$maxScore',
                style: AppStyles.font20Bold(context).copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6.h,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          18.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFFFE082).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🏆',
                  style: TextStyle(fontSize: 16),
                ),
                8.horizontalSpace,
                Text(
                  'أنت ضمن أعلى 20% من الطلاب',
                  style: AppStyles.font13Medium(context).copyWith(
                    color: const Color(0xFF8D6E63),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

