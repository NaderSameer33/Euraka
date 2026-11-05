import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../logic/otp_cubit.dart';
import '../../logic/otp_state.dart';

class OtpResendCard extends StatelessWidget {
  final OtpCubit cubit;
  final OtpState state;

  const OtpResendCard({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sync_rounded,
            color: AppColors.primary,
            size: 24.sp,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لم تستلم الرمز ؟',
                  style: AppStyles.font14Bold(context),
                ),
                2.verticalSpace,
                Text(
                  'يمكنك اعاده ارسال الرمز مره اخري',
                  style: AppStyles.font12Regular(context),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: state.canResend ? cubit.resendOtp : null,
            borderRadius: BorderRadius.circular(6.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Text(
                'اعاده ارسال الرمز',
                style: state.canResend
                    ? AppStyles.font12MediumPrimary
                    : AppStyles.font12Regular(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
