import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/widgets/app_success_dialog.dart';
import '../components/reset_password_form.dart';
import '../components/reset_password_header.dart';
import '../../logic/reset_password_cubit.dart';
import '../../logic/reset_password_state.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String? resetToken;

  const ResetPasswordView({
    super.key,
    this.email = 'student.journey@eureka-test.com',
    this.resetToken,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(
        email: email,
        resetToken: resetToken,
      ),
      child: const _ResetPasswordViewBody(),
    );
  }
}

class _ResetPasswordViewBody extends StatelessWidget {
  const _ResetPasswordViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordErrorState) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.fillColored,
                title: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            } else if (state is ResetPasswordSuccessState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AppSuccessDialog(
                  title: 'تم تحديث كلمه المرور بنجاح',
                  subtitle: 'يمكنك الان تسجيل الدخول باستخدام\nكلمه المرور الجديده',
                  buttonText: 'متابعه',
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go(AppRouterName.login);
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  const ResetPasswordHeader(),
                  24.verticalSpace,
                  ResetPasswordForm(
                    cubit: cubit,
                    state: state,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

