import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/theme/app_styles.dart';

class SplashLogoWidget extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final Animation<double> slideAnimation;

  const SplashLogoWidget({
    super.key,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnimation, fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Opacity(
              opacity: fadeAnimation.value.clamp(0.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.appLogo,
                    width: 96.w,
                    height: 132.h,
                    fit: BoxFit.contain,
                  ),
                  16.verticalSpace,
                  Text(
                    'يوريكا',
                    style: AppStyles.font34Bold(context),
                  ),
                  4.verticalSpace,
                  Text(
                    'EUREKA',
                    style: AppStyles.font13MediumLetterSpacing(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
