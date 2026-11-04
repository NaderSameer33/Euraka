import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/widgets/app_button.dart';
import 'onboarding_indicator.dart';

class OnboardingBottomBar extends StatelessWidget {
  final int totalCount;
  final int currentIndex;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;

  const OnboardingBottomBar({
    super.key,
    required this.totalCount,
    required this.currentIndex,
    required this.isLastPage,
    required this.onNext,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingIndicator(
            count: totalCount,
            currentIndex: currentIndex,
          ),
          28.verticalSpace,
          AppButton(
            text: isLastPage ? 'ابدأ الآن' : 'التالي',
            onPressed: isLastPage ? onGetStarted : onNext,
          ),
        ],
      ),
    );
  }
}

