import 'package:equatable/equatable.dart';
import '../data/models/reset_password_response_model.dart';

abstract class ResetPasswordState extends Equatable {
  final bool isCurrentPasswordObscured;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final double passwordStrength;
  final bool isLengthValid;
  final bool hasNumber;
  final bool hasSpecialChar;

  const ResetPasswordState({
    this.isCurrentPasswordObscured = true,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.passwordStrength = 0.0,
    this.isLengthValid = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
  });

  @override
  List<Object?> get props => [
        isCurrentPasswordObscured,
        isNewPasswordObscured,
        isConfirmPasswordObscured,
        passwordStrength,
        isLengthValid,
        hasNumber,
        hasSpecialChar,
      ];
}

class ResetPasswordInitialState extends ResetPasswordState {
  const ResetPasswordInitialState({
    super.isCurrentPasswordObscured,
    super.isNewPasswordObscured,
    super.isConfirmPasswordObscured,
    super.passwordStrength,
    super.isLengthValid,
    super.hasNumber,
    super.hasSpecialChar,
  });
}

class ResetPasswordUpdatedState extends ResetPasswordState {
  const ResetPasswordUpdatedState({
    super.isCurrentPasswordObscured,
    super.isNewPasswordObscured,
    super.isConfirmPasswordObscured,
    super.passwordStrength,
    super.isLengthValid,
    super.hasNumber,
    super.hasSpecialChar,
  });
}

class ResetPasswordLoadingState extends ResetPasswordState {
  const ResetPasswordLoadingState({
    super.isCurrentPasswordObscured,
    super.isNewPasswordObscured,
    super.isConfirmPasswordObscured,
    super.passwordStrength,
    super.isLengthValid,
    super.hasNumber,
    super.hasSpecialChar,
  });
}

class ResetPasswordSuccessState extends ResetPasswordState {
  final ResetPasswordResponseModel response;

  const ResetPasswordSuccessState({
    required this.response,
    super.isCurrentPasswordObscured,
    super.isNewPasswordObscured,
    super.isConfirmPasswordObscured,
    super.passwordStrength,
    super.isLengthValid,
    super.hasNumber,
    super.hasSpecialChar,
  });

  @override
  List<Object?> get props => [response, ...super.props];
}

class ResetPasswordErrorState extends ResetPasswordState {
  final String message;

  const ResetPasswordErrorState({
    required this.message,
    super.isCurrentPasswordObscured,
    super.isNewPasswordObscured,
    super.isConfirmPasswordObscured,
    super.passwordStrength,
    super.isLengthValid,
    super.hasNumber,
    super.hasSpecialChar,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}

