import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../components/otp_header.dart';
import '../components/otp_input_fields.dart';
import '../components/otp_resend_card.dart';
import '../components/otp_timer_widget.dart';
import '../../logic/otp_cubit.dart';
import '../../logic/otp_state.dart';

class OtpView extends StatelessWidget {
  final String email;
  final String? token;

  const OtpView({
    super.key,
    this.email = 'ahmed@gmail.com',
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(
        email: email,
        token: token,
      ),
      child: const _OtpViewBody(),
    );
  }
}

class _OtpViewBody extends StatelessWidget {
  const _OtpViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpSuccessState) {
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
                  OtpHeader(email: cubit.effectiveEmail),
                  24.verticalSpace,
                  OtpInputFields(
                    cubit: cubit,
                    state: state,
                  ),
                  16.verticalSpace,
                  OtpTimerWidget(
                    remainingSeconds: state.remainingSeconds,
                  ),
                  20.verticalSpace,
                  OtpResendCard(
                    cubit: cubit,
                    state: state,
                  ),
                  24.verticalSpace,
                  AppButton(
                    text: 'تحقق من الرمز',
                    isLoading: state is OtpLoadingState,
                    onPressed: () => cubit.verifyOtp(context),
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

