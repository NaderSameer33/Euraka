import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/animated_theme_switcher.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

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
          'مرحبا بك في يوريكا',
          style: AppStyles.font24Bold(context),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          'سجل دخولك لمتابعه رحلتك التعليميه',
          style: AppStyles.font14Regular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

