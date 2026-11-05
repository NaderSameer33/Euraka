import 'package:equatable/equatable.dart';
import '../data/models/verify_email_response_model.dart';

abstract class OtpState extends Equatable {
  final String otpCode;
  final int remainingSeconds;
  final bool canResend;

  const OtpState({
    this.otpCode = '',
    this.remainingSeconds = 59,
    this.canResend = false,
  });

  @override
  List<Object?> get props => [otpCode, remainingSeconds, canResend];
}

class OtpInitialState extends OtpState {
  const OtpInitialState({
    super.otpCode,
    super.remainingSeconds,
    super.canResend,
  });
}

class OtpCodeChangedState extends OtpState {
  const OtpCodeChangedState({
    required super.otpCode,
    required super.remainingSeconds,
    required super.canResend,
  });
}

class OtpTimerTickState extends OtpState {
  const OtpTimerTickState({
    required super.otpCode,
    required super.remainingSeconds,
    required super.canResend,
  });
}

class OtpLoadingState extends OtpState {
  const OtpLoadingState({
    required super.otpCode,
    required super.remainingSeconds,
    required super.canResend,
  });
}

class OtpSuccessState extends OtpState {
  final VerifyEmailResponseModel response;

  const OtpSuccessState({
    required this.response,
    required super.otpCode,
    required super.remainingSeconds,
    required super.canResend,
  });

  @override
  List<Object?> get props => [response, otpCode, remainingSeconds, canResend];
}

class OtpErrorState extends OtpState {
  final String message;

  const OtpErrorState({
    required this.message,
    required super.otpCode,
    required super.remainingSeconds,
    required super.canResend,
  });

  @override
  List<Object?> get props => [message, otpCode, remainingSeconds, canResend];
}

