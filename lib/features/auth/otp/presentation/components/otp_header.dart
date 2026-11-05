import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';

class OtpHeader extends StatelessWidget {
  final String email;

  const OtpHeader({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        8.verticalSpace,
        Center(
          child: Image.asset(
            AppAssets.verifyImage,
            height: 200.h,
            fit: BoxFit.contain,
          ),
        ),
        16.verticalSpace,
        Text(
          'تحقق من بريدك الالكتروني',
          style: AppStyles.font20Bold(context),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'لقد ارسلنا رمز التحقق مكون\nمن 6 ارقام الي ',
                style: AppStyles.font14Regular(context),
              ),
              TextSpan(
                text: email,
                style: AppStyles.font14MediumPrimary,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
