import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_font_weight.dart';
import '../../../../../../core/theme/app_styles.dart';

class TeacherKpiCard extends StatelessWidget {
  final Widget icon;
  final String value;
  final String title;
  final num growthPercent;
  final Color accentColor;

  const TeacherKpiCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.growthPercent,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardBgColor = Color.alphaBlend(
      accentColor.withValues(alpha: 0.10),
      theme.scaffoldBackgroundColor,
    );
    final growthText = '${growthPercent >= 0 ? '+' : ''}${growthPercent.toInt()}%';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: Center(child: icon),
          ),
          8.verticalSpace,
          Text(
            value,
            style: AppStyles.font24Bold(context).copyWith(
              fontSize: 26.sp,
              fontWeight: AppFontWeight.black,
              height: 1.1,
            ),
          ),
          4.verticalSpace,
          Text(
            title,
            style: AppStyles.font12Medium(context),
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                growthPercent >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 11.sp,
                color: accentColor,
              ),
              2.horizontalSpace,
              Text(
                growthText,
                style: AppStyles.font12Medium(context).copyWith(
                  fontSize: 10.sp,
                  fontWeight: AppFontWeight.bold,
                  color: accentColor,
                ),
              ),
              4.horizontalSpace,
              Flexible(
                child: Text(
                  'عن الأسبوع الماضي',
                  style: AppStyles.font12Regular(context).copyWith(
                    fontSize: 10.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
