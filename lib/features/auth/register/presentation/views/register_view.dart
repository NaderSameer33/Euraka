import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/widgets/auth_divider.dart';
import '../components/register_footer.dart';
import '../components/register_form.dart';
import '../components/register_header.dart';
import '../../logic/register_cubit.dart';
import '../../logic/register_state.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const _RegisterViewBody(),
    );
  }
}

class _RegisterViewBody extends StatelessWidget {
  const _RegisterViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterErrorState) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.fillColored,
                title: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            } else if (state is RegisterSuccessState) {
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
                  const RegisterHeader(),
                  28.verticalSpace,
                  RegisterForm(
                    cubit: cubit,
                    state: state,
                  ),
                  28.verticalSpace,
                  const AuthDivider(),
                  20.verticalSpace,
                  const RegisterFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

