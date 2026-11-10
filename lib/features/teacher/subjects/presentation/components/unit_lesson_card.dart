import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/subject_unit_model.dart';

class UnitLessonCard extends StatelessWidget {
  final UnitLessonModel lesson;
  final int index;
  final VoidCallback? onTap;

  const UnitLessonCard({
    super.key,
    required this.lesson,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHighlighted = index < 2;

    final numberFormatted =
        (lesson.lessonNumber > 0 ? lesson.lessonNumber : index + 1).toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.primary.withValues(alpha: 0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isHighlighted
                ? AppColors.primary.withValues(alpha: 0.35)
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lesson.title,
                    style: AppStyles.font14Bold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    lesson.chapterTitle,
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 16.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    2.verticalSpace,
                    Text(
                      '${lesson.pdfCount} PDF',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 10.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                10.horizontalSpace,
                Container(
                  width: 1.w,
                  height: 22.h,
                  color: colorScheme.outline.withValues(alpha: 0.35),
                ),
                10.horizontalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 16.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    2.verticalSpace,
                    Text(
                      '${lesson.videoCount} فيديو',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 10.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                12.horizontalSpace,
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    numberFormatted,
                    style: AppStyles.font14Bold(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
