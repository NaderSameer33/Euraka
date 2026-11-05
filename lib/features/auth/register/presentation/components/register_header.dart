import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/animated_theme_switcher.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: const AnimatedThemeSwitcher(),
        ),
        8.verticalSpace,
        Center(
          child: Column(
            children: [
              Image.asset(
                AppAssets.appLogo,
                height: 72.h,
                fit: BoxFit.contain,
              ),
              8.verticalSpace,
              Text(
                'يوريكا',
                style: AppStyles.font20Bold(context),
              ),
            ],
          ),
        ),
        24.verticalSpace,
        Text(
          'انشاء حساب جديد',
          style: AppStyles.font24Bold(context),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          'انضم الي مجتمعنا التعليمي وابدا\nرحلتك نحو التعلم والتطور',
          style: AppStyles.font14Regular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

