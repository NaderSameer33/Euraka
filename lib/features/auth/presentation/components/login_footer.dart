import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/theme/app_styles.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ليس لديك حساب ؟',
          style: AppStyles.font14Regular(context),
          textAlign: TextAlign.center,
        ),
        4.verticalSpace,
        TextButton(
          onPressed: () => context.push(AppRouterName.register),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'انشاء حساب',
            style: AppStyles.font16BoldPrimary,
          ),
        ),
      ],
    );
  }
}

