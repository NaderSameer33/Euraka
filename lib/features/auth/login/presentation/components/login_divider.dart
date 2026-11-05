import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.outline.withValues(alpha: 0.25);
    final iconColor = theme.colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SvgPicture.asset(
            AppAssets.accountIcon,
            width: 24.sp,
            height: 24.sp,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}

