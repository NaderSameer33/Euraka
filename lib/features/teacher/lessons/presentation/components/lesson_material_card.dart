import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/lesson_model.dart';

class LessonMaterialCard extends StatelessWidget {
  final LessonMaterialModel material;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LessonMaterialCard({
    super.key,
    required this.material,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          _buildBadge(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  material.name,
                  style: AppStyles.font14Bold(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                2.verticalSpace,
                Text(
                  material.formattedFileSize,
                  style: AppStyles.font12Regular(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null) ...[
            8.horizontalSpace,
            GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (onDelete != null) ...[
            6.horizontalSpace,
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 20.sp,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge() {
    if (material.isPdf) {
      return Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          'PDF',
          style: TextStyle(
            color: const Color(0xFFEF4444),
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (material.isImage) {
      return Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: AppColors.primary,
          size: 20.sp,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: const Color(0xFF7B61FF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.movie_creation_outlined,
        color: const Color(0xFF7B61FF),
        size: 20.sp,
      ),
    );
  }
}
