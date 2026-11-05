import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../logic/forgot_password_cubit.dart';
import '../../logic/forgot_password_state.dart';

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordCubit cubit;
  final ForgotPasswordState state;

  const ForgotPasswordForm({
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
            hintText: 'ادخل بريدك الالكتروني',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: AppValidator.validateEmail,
            onFieldSubmitted: (_) => cubit.sendResetCode(context),
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
          24.verticalSpace,
          AppButton(
            text: 'ارسال رمز التحقق',
            isLoading: state is ForgotPasswordLoadingState,
            onPressed: () => cubit.sendResetCode(context),
          ),
        ],
      ),
    );
  }
}
