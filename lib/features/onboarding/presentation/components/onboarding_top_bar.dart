import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class OnboardingTopBar extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.isLastPage,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          AnimatedOpacity(
            opacity: isLastPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: isLastPage
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                    child: Text(
                      'تخطي',
                      style: AppStyles.font14Medium(context),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

