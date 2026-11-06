import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helper/helper_method.dart';
import '../../../../core/routers/app_router_name.dart';
import '../data/models/verify_email_request_body.dart';
import '../data/models/verify_email_response_model.dart';
import '../data/repos/otp_repo.dart';
import 'otp_state.dart';

class OtpCubit extends SafeCubit<OtpState> {
  final OtpRepo _otpRepo;
  final SharedPrefService _sharedPrefService;
  final String email;
  final String? token;
  final bool isForgotPassword;

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  Timer? _timer;

  OtpCubit(
    this._otpRepo,
    this._sharedPrefService, {
    required this.email,
    this.token,
    this.isForgotPassword = false,
  }) : super(const OtpInitialState()) {
    _startTimer();
  }

  String get effectiveEmail {
    if (email.isNotEmpty && email != 'ahmed@gmail.com') {
      return email;
    }
    final cached = _sharedPrefService.getString(AppConstants.userEmailKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    return email;
  }

  void _startTimer() {
    _timer?.cancel();
    emit(OtpInitialState(
      otpCode: getOtpCode(),
      remainingSeconds: 600,
      canResend: false,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        final nextSeconds = state.remainingSeconds - 1;
        emit(OtpTimerTickState(
          otpCode: getOtpCode(),
          remainingSeconds: nextSeconds,
          canResend: nextSeconds <= 540,
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

  String _normalizeDigits(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const eastern = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(arabic[i], '$i').replaceAll(eastern[i], '$i');
    }
    return result.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String getOtpCode() {
    return _normalizeDigits(controllers.map((c) => c.text).join());
  }

  void onDigitChanged(int index, String value, BuildContext context) {
    final cleaned = _normalizeDigits(value);

    if (cleaned.length >= 6) {
      for (int i = 0; i < 6; i++) {
        controllers[i].text = cleaned[i];
      }
      focusNodes[5].unfocus();
      final code = getOtpCode();
      emit(OtpCodeChangedState(
        otpCode: code,
        remainingSeconds: state.remainingSeconds,
        canResend: state.canResend,
      ));
      if (state is! OtpLoadingState) {
        verifyOtp(context);
      }
      return;
    }

    if (cleaned.isNotEmpty) {
      controllers[index].text = cleaned.substring(cleaned.length - 1);
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      controllers[index].clear();
    }

    final code = getOtpCode();
    emit(OtpCodeChangedState(
      otpCode: code,
      remainingSeconds: state.remainingSeconds,
      canResend: state.canResend,
    ));

    if (code.length == 6 && state is! OtpLoadingState) {
      verifyOtp(context);
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    if (!state.canResend) return;
    for (final controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
    _startTimer();

    final targetEmail = effectiveEmail;
    final result = isForgotPassword
        ? await _otpRepo.resendForgotPasswordOtp(email: targetEmail)
        : await _otpRepo.resendVerificationEmail(token: token);

    result.fold(
      (failure) {
        if (context.mounted) {
          HelperMethod.showErrorToast(
            context: context,
            message: failure.message,
          );
        }
      },
      (_) {
        if (context.mounted) {
          HelperMethod.showSuccessToast(
            context: context,
            message: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
          );
        }
      },
    );
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (state is OtpLoadingState) return;

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

    final targetEmail = effectiveEmail;

    if (isForgotPassword) {
      final result = await _otpRepo.verifyOtp(
        email: targetEmail,
        otpCode: code,
      );
      result.fold(
        (failure) {
          emit(OtpErrorState(
            message: failure.message,
            otpCode: code,
            remainingSeconds: state.remainingSeconds,
            canResend: state.canResend,
          ));
        },
        (response) {
          String? resetToken;
          if (response is Map) {
            resetToken = response['data']?['resetToken'] as String? ??
                response['resetToken'] as String?;
          }
          emit(OtpSuccessState(
            response: VerifyEmailResponseModel(
              success: true,
              statusCode: 200,
              message: response is Map
                  ? (response['message'] as String? ?? 'تم التحقق من الرمز بنجاح')
                  : 'تم التحقق من الرمز بنجاح',
            ),
            otpCode: code,
            remainingSeconds: state.remainingSeconds,
            canResend: state.canResend,
          ));
          if (context.mounted) {
            context.push(
              AppRouterName.resetPassword,
              extra: {
                'email': targetEmail,
                'resetToken': resetToken,
              },
            );
          }
        },
      );
      return;
    }

    final result = await _otpRepo.verifyEmail(
      VerifyEmailRequestBody(otpCode: code),
      token: token,
    );

    result.fold(
      (failure) {
        emit(OtpErrorState(
          message: failure.message,
          otpCode: code,
          remainingSeconds: state.remainingSeconds,
          canResend: state.canResend,
        ));
      },
      (response) {
        emit(OtpSuccessState(
          response: response,
          otpCode: code,
          remainingSeconds: state.remainingSeconds,
          canResend: state.canResend,
        ));
        if (context.mounted) {
          context.go(AppRouterName.login);
        }
      },
    );
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

