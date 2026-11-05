import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';

class LoginForm extends StatelessWidget {
  final LoginCubit cubit;
  final LoginState state;

  const LoginForm({
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
            controller: cubit.passwordController,
            title: 'كلمه المرور',
            hintText: 'ادخل كلمه المرور',
            isObscure: state.isPasswordObscured,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => cubit.login(context),
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
          12.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push(AppRouterName.forgotPassword),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'هل نسيت كلمة المرور؟',
                style: AppStyles.font14MediumPrimary,
              ),
            ),
          ),
          24.verticalSpace,
          AppButton(
            text: 'تسجيل الدخول',
            isLoading: state is LoginLoadingState,
            onPressed: () => cubit.login(context),
          ),
        ],
      ),
    );
  }
}

