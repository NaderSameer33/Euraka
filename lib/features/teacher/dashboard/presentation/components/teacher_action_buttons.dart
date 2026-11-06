import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  color: isDark ? AppColors.surfaceDark : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'اضافه مجموعه',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
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
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'اضافه امتحان',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

