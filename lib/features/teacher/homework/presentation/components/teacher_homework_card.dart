import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_homework_model.dart';
import 'homework_date_picker_bottom_sheet.dart';

class TeacherHomeworkCard extends StatelessWidget {
  final TeacherHomeworkModel homework;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TeacherHomeworkCard({
    super.key,
    required this.homework,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    DateTime? parsedDue;
    try {
      parsedDue = DateTime.parse(homework.dueDate);
    } catch (_) {}

    final formattedDate = parsedDue != null
        ? ArabicDateHelper.formatFull(parsedDue)
        : homework.dueDate;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    homework.title,
                    style: AppStyles.font16Bold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                10.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${homework.totalScore} درجة',
                    style: AppStyles.font12Medium(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                if (homework.groupName != null && homework.groupName!.isNotEmpty) ...[
                  Text(
                    homework.groupName!,
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    '•',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 12.sp,
                    ),
                  ),
                  8.horizontalSpace,
                ],
                if (homework.subjectName != null && homework.subjectName!.isNotEmpty) ...[
                  Text(
                    homework.subjectName!,
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
            12.verticalSpace,
            Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 16.r,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    6.horizontalSpace,
                    Text(
                      '${homework.questionsCount} أسئلة',
                      style: AppStyles.font12Medium(context).copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    12.horizontalSpace,
                    Icon(
                      Icons.people_outline_rounded,
                      size: 16.r,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    6.horizontalSpace,
                    Text(
                      '${homework.submissionsCount} تم الحل',
                      style: AppStyles.font12Medium(context).copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.r,
                      color: Colors.redAccent.withValues(alpha: 0.8),
                    ),
                    4.horizontalSpace,
                    Text(
                      '${homework.remainingDays} يوم متبقي',
                      style: AppStyles.font11SemiBold(context).copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            8.verticalSpace,
            Text(
              'موعد التسليم: $formattedDate',
              style: AppStyles.font11SemiBold(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

