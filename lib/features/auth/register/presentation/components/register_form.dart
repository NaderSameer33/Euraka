import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../logic/register_cubit.dart';
import '../../logic/register_state.dart';

class RegisterForm extends StatelessWidget {
  final RegisterCubit cubit;
  final RegisterState state;

  const RegisterForm({
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
            controller: cubit.nameController,
            title: 'الاسم',
            hintText: 'ادخل الاسم الثلاثي',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: AppValidator.validateName,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.personIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          16.verticalSpace,
          AppInput(
            controller: cubit.emailController,
            title: 'البريد الالكتروني',
            hintText: 'ادخل بريدك الالكتروني',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: AppValidator.validateEmail,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.emailIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          16.verticalSpace,
          AppInput(
            controller: cubit.phoneController,
            title: 'رقم الهاتف',
            hintText: 'ادخل رقم الهاتف',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: AppValidator.validatePhone,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: SvgPicture.asset(
                AppAssets.phoneIcon,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          16.verticalSpace,
          AppInput(
            controller: cubit.passwordController,
            title: 'كلمه المرور',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isPasswordObscured,
            textInputAction: TextInputAction.next,
            validator: AppValidator.validatePassword,
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
              onPressed: cubit.togglePasswordVisibility,
              icon: SvgPicture.asset(
                state.isPasswordObscured
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
            controller: cubit.confirmPasswordController,
            title: 'تاكيد كلمه المرور',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isConfirmPasswordObscured,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => cubit.register(context),
            validator: (value) => AppValidator.validateConfirmPassword(
              value,
              cubit.passwordController.text,
            ),
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
          24.verticalSpace,
          AppButton(
            text: 'انشاء حساب جديد',
            isLoading: state is RegisterLoadingState,
            onPressed: () => cubit.register(context),
          ),
        ],
      ),
    );
  }
}

