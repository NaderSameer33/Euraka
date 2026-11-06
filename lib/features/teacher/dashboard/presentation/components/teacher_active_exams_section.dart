import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_font_weight.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_dashboard_response_model.dart';

class TeacherActiveExamsSection extends StatelessWidget {
  final List<TeacherActiveExamModel> exams;
  final VoidCallback? onViewAllPressed;

  const TeacherActiveExamsSection({
    super.key,
    required this.exams,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الامتحانات النشطه',
              style: AppStyles.font16Bold(context).copyWith(
                fontWeight: AppFontWeight.extraBold,
              ),
            ),
            GestureDetector(
              onTap: onViewAllPressed ?? () {},
              child: Text(
                'عرض الكل',
                style: AppStyles.font14MediumPrimary.copyWith(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        if (exams.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Text(
              'لا توجد امتحانات نشطة حالياً',
              style: AppStyles.font14Regular(context).copyWith(
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          )
        else
          ...exams.map((exam) => _ExamCard(exam: exam)),
      ],
    );
  }
}

class _ExamCard extends StatelessWidget {
  final TeacherActiveExamModel exam;

  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF381524) : const Color(0xFFFDF2F8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.assignment_outlined,
                size: 24.sp,
                color: const Color(0xFFE11D48),
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  exam.title.isNotEmpty ? exam.title : exam.groupName,
                  style: AppStyles.font14Bold(context).copyWith(
                    color: isDark ? AppColors.white : const Color(0xFF13181D),
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${exam.durationMinutes} دقيقة',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.timer_outlined,
                      size: 13.sp,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF9CA3AF),
                    ),
                    12.horizontalSpace,
                    Text(
                      '${exam.submissionsCount} تم التسليم',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14.sp,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
