import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class TeacherTabPlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const TeacherTabPlaceholderView({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 54.sp,
              color: AppColors.primary,
            ),
            16.verticalSpace,
            Text(
              title,
              style: AppStyles.font18Bold(context),
            ),
            8.verticalSpace,
            Text(
              'قريباً',
              style: AppStyles.font14Regular(context),
            ),
          ],
        ),
      ),
    );
  }
}
