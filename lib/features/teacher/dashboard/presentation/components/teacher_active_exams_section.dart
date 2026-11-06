import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outline,
              ),
            ),
            child: Text(
              'لا توجد امتحانات نشطة حالياً',
              style: AppStyles.font14Regular(context),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
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
              color: colorScheme.error.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.assignment_outlined,
                size: 24.sp,
                color: colorScheme.error,
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
                  style: AppStyles.font14Bold(context),
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
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.timer_outlined,
                      size: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    12.horizontalSpace,
                    Text(
                      '${exam.submissionsCount} تم التسليم',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14.sp,
                      color: colorScheme.onSurfaceVariant,
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
