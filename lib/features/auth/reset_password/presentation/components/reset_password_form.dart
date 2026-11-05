import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../logic/reset_password_cubit.dart';
import '../../logic/reset_password_state.dart';
import 'password_requirements_card.dart';
import 'password_strength_indicator.dart';

class ResetPasswordForm extends StatelessWidget {
  final ResetPasswordCubit cubit;
  final ResetPasswordState state;

  const ResetPasswordForm({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInput(
            controller: cubit.currentPasswordController,
            title: 'كلمه المرور الحاليه',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isCurrentPasswordObscured,
            textInputAction: TextInputAction.next,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.lockIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: cubit.toggleCurrentPasswordVisibility,
              icon: SvgPicture.asset(
                state.isCurrentPasswordObscured
                    ? AppAssets.visibilityOffIcon
                    : AppAssets.visibilityIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          16.verticalSpace,
          AppInput(
            controller: cubit.newPasswordController,
            title: 'كلمه المرور الجديده',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isNewPasswordObscured,
            textInputAction: TextInputAction.next,
            validator: AppValidator.validatePassword,
            onChanged: cubit.onNewPasswordChanged,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.lockIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: cubit.toggleNewPasswordVisibility,
              icon: SvgPicture.asset(
                state.isNewPasswordObscured
                    ? AppAssets.visibilityOffIcon
                    : AppAssets.visibilityIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          8.verticalSpace,
          PasswordStrengthIndicator(strength: state.passwordStrength),
          16.verticalSpace,
          AppInput(
            controller: cubit.confirmPasswordController,
            title: 'تاكيد كلمه المرور',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isConfirmPasswordObscured,
            textInputAction: TextInputAction.done,
            validator: (value) => AppValidator.validateConfirmPassword(
              value,
              cubit.newPasswordController.text,
            ),
            onFieldSubmitted: (_) => cubit.resetPassword(context),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.lockIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: cubit.toggleConfirmPasswordVisibility,
              icon: SvgPicture.asset(
                state.isConfirmPasswordObscured
                    ? AppAssets.visibilityOffIcon
                    : AppAssets.visibilityIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          16.verticalSpace,
          PasswordRequirementsCard(
            isLengthValid: state.isLengthValid,
            hasNumber: state.hasNumber,
            hasSpecialChar: state.hasSpecialChar,
          ),
          24.verticalSpace,
          AppButton(
            text: 'تحديث كلمه المرور',
            isLoading: state is ResetPasswordLoadingState,
            onPressed: () => cubit.resetPassword(context),
          ),
        ],
      ),
    );
  }
}
