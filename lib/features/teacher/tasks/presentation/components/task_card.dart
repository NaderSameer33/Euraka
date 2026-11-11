import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_task_card_model.dart';

class TaskCard extends StatelessWidget {
  final TeacherTaskCardModel task;
  final VoidCallback? onActionTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardBackgroundColor = Color.alphaBlend(
      task.badgeColor.withValues(alpha: 0.05),
      colorScheme.surface,
    );

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: task.badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        task.badgeIcon,
                        color: task.badgeColor,
                        size: 22.sp,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppStyles.font16Bold(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text(
                  task.description,
                  style: AppStyles.font12Regular(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                14.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: onActionTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      task.buttonText,
                      style: AppStyles.font14Bold(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          SizedBox(
            width: 105.w,
            height: 105.h,
            child: Image.asset(
              task.imageAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  task.badgeIcon,
                  color: task.badgeColor.withValues(alpha: 0.5),
                  size: 48.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

