import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../components/forgot_password_form.dart';
import '../components/forgot_password_header.dart';
import '../../logic/forgot_password_cubit.dart';
import '../../logic/forgot_password_state.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: const _ForgotPasswordViewBody(),
    );
  }
}

class _ForgotPasswordViewBody extends StatelessWidget {
  const _ForgotPasswordViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordErrorState) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.fillColored,
                title: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            } else if (state is ForgotPasswordSuccessState) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(state.response.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  const ForgotPasswordHeader(),
                  32.verticalSpace,
                  ForgotPasswordForm(
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
