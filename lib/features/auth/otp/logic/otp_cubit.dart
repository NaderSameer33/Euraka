import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/verify_email_request_body.dart';
import '../data/repos/otp_repo.dart';
import 'otp_state.dart';

class OtpCubit extends SafeCubit<OtpState> {
  final OtpRepo _otpRepo;
  final String email;
  final String? token;

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  Timer? _timer;

  OtpCubit({
    OtpRepo? otpRepo,
    required this.email,
    this.token,
  })  : _otpRepo = otpRepo ?? getIt<OtpRepo>(),
        super(const OtpInitialState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(OtpInitialState(
      otpCode: getOtpCode(),
      remainingSeconds: 59,
      canResend: false,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        emit(OtpTimerTickState(
          otpCode: getOtpCode(),
          remainingSeconds: state.remainingSeconds - 1,
          canResend: false,
        ));
      } else {
        timer.cancel();
        emit(OtpTimerTickState(
          otpCode: getOtpCode(),
          remainingSeconds: 0,
          canResend: true,
        ));
      }
    });
  }

  String getOtpCode() {
    return controllers.map((c) => c.text).join();
  }

  void onDigitChanged(int index, String value, BuildContext context) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        controllers[index].text = value.substring(value.length - 1);
      }
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }

    final code = getOtpCode();
    emit(OtpCodeChangedState(
      otpCode: code,
      remainingSeconds: state.remainingSeconds,
      canResend: state.canResend,
    ));

    if (code.length == 6) {
      verifyOtp(context);
    }
  }

  void resendOtp() {
    if (!state.canResend) return;
    for (final controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
    _startTimer();
  }

  Future<void> verifyOtp(BuildContext context) async {
    final code = getOtpCode();
    if (code.length < 6) {
      emit(OtpErrorState(
        message: 'الرمز غير صحيح حاول مره اخري',
        otpCode: code,
        remainingSeconds: state.remainingSeconds,
        canResend: state.canResend,
      ));
      return;
    }

    emit(OtpLoadingState(
      otpCode: code,
      remainingSeconds: state.remainingSeconds,
      canResend: state.canResend,
    ));

    final result = await _otpRepo.verifyEmail(
      VerifyEmailRequestBody(otpCode: code),
      token: token,
    );

    if (result.failure != null) {
      emit(OtpErrorState(
        message: result.failure!.message,
        otpCode: code,
        remainingSeconds: state.remainingSeconds,
        canResend: state.canResend,
      ));
    } else if (result.response != null) {
      emit(OtpSuccessState(
        response: result.response!,
        otpCode: code,
        remainingSeconds: state.remainingSeconds,
        canResend: state.canResend,
      ));
      if (context.mounted) {
        final role = _otpRepo.getSavedRole();
        if (role == 'TEACHER') {
          context.go(AppRouterName.teacherHome);
        } else {
          context.go(AppRouterName.studentHome);
        }
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    return super.close();
  }
}

