import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../logic/otp_cubit.dart';
import '../../logic/otp_state.dart';

class OtpInputFields extends StatelessWidget {
  final OtpCubit cubit;
  final OtpState state;

  const OtpInputFields({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isError = state is OtpErrorState;
    final defaultBorderColor = theme.colorScheme.outline.withValues(alpha: isDark ? 0.35 : 0.6);

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 48.w,
                height: 54.h,
                child: TextField(
                  controller: cubit.controllers[index],
                  focusNode: cubit.focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: AppStyles.font20Bold(context),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: isError
                        ? AppColors.error.withValues(alpha: 0.1)
                        : (isDark ? AppColors.inputFillDark : AppColors.inputFillLight),
                    hintText: '—',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                      fontSize: 16.sp,
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: isError ? AppColors.error : defaultBorderColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: isError ? AppColors.error : defaultBorderColor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: isError ? AppColors.error : AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (val) => cubit.onDigitChanged(index, val, context),
                ),
              );
            }),
          ),
        ),
        if (isError) ...[
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: AppColors.error,
                size: 16.sp,
              ),
              6.horizontalSpace,
              Text(
                (state as OtpErrorState).message,
                style: AppStyles.font12MediumError,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

