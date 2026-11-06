import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_styles.dart';

class TeacherActionButtons extends StatelessWidget {
  final VoidCallback? onAddExamPressed;
  final VoidCallback? onAddGroupPressed;

  const TeacherActionButtons({
    super.key,
    this.onAddExamPressed,
    this.onAddGroupPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddGroupPressed ?? () {},
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'اضافه امتحان',
                  style: AppStyles.font16BoldPrimary.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddExamPressed ?? () {},
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'اضافه مجموعه',
                  style: AppStyles.font16BoldWhite.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
