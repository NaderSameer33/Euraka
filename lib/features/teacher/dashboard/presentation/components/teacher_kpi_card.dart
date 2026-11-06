import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class TeacherKpiCard extends StatelessWidget {
  final Widget icon;
  final String value;
  final String title;
  final num growthPercent;
  final Color accentColor;
  final Color lightBgColor;
  final Color darkBgColor;

  const TeacherKpiCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.growthPercent,
    required this.accentColor,
    required this.lightBgColor,
    required this.darkBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final growthText = '${growthPercent >= 0 ? '+' : ''}${growthPercent.toInt()}%';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : lightBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? accentColor.withValues(alpha: 0.15) : accentColor.withValues(alpha: 0.12),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
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
            style: TextStyle(
              fontFamily: AppStyles.fontFamily,
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.white : const Color(0xFF13181D),
              height: 1.1,
            ),
          ),
          4.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontFamily: AppStyles.fontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
            ),
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
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              4.horizontalSpace,
              Flexible(
                child: Text(
                  'عن الأسبوع الماضي',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 10.sp,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
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

