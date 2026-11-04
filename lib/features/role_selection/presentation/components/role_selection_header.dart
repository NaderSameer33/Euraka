import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/animated_theme_switcher.dart';

class RoleSelectionHeader extends StatelessWidget {
  const RoleSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRouterName.onboarding);
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const AnimatedThemeSwitcher(),
          ],
        ),
        24.verticalSpace,
        Center(
          child: Image.asset(
            AppAssets.appLogo,
            height: 64.h,
            fit: BoxFit.contain,
          ),
        ),
        20.verticalSpace,
        Text(
          'اختر نوع حسابك',
          style: AppStyles.font24Bold(context),
        ),
        8.verticalSpace,
        Text(
          'حدد دورك في المنصة للبدء في تجربة تعليمية مخصصة لك',
          style: AppStyles.font14Regular(context),
        ),
      ],
    );
  }
}
