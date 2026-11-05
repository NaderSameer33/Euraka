import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../components/login_divider.dart';
import '../components/login_footer.dart';
import '../components/login_form.dart';
import '../components/login_header.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.fillColored,
                title: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  const LoginHeader(),
                  28.verticalSpace,
                  LoginForm(
                    cubit: cubit,
                    state: state,
                  ),
                  28.verticalSpace,
                  const LoginDivider(),
                  20.verticalSpace,
                  const LoginFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

