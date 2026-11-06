import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/services/get_it_service.dart';
import '../components/forgot_password_form.dart';
import '../components/forgot_password_header.dart';
import '../../logic/forgot_password_cubit.dart';
import '../../logic/forgot_password_state.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordCubit>(),
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
              HelperMethod.showErrorToast(
                context: context,
                message: state.message,
              );
            } else if (state is ForgotPasswordSuccessState) {
              HelperMethod.showSuccessToast(
                context: context,
                message: state.response.message,
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

