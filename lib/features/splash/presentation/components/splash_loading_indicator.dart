import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class SplashLoadingIndicator extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashLoadingIndicator({
    super.key,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48.w,
            height: 3.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: const LinearProgressIndicator(
                backgroundColor: AppColors.primaryLight,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'منصة التعلم الذكية',
            style: AppStyles.font14RegularMuted(context),
          ),
        ],
      ),
    );
  }
}
