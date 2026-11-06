import 'package:flutter/material.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../data/models/reset_password_request_body.dart';
import '../data/repos/reset_password_repo.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends SafeCubit<ResetPasswordState> {
  final ResetPasswordRepo _repo;
  final SharedPrefService _sharedPrefService;
  final String email;
  final String? resetToken;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordCubit(
    this._repo,
    this._sharedPrefService, {
    required this.email,
    this.resetToken,
  }) : super(const ResetPasswordInitialState());

  String get effectiveEmail {
    if (email.isNotEmpty && email != 'student.journey@eureka-test.com') {
      return email;
    }
    final cached = _sharedPrefService.getString(AppConstants.userEmailKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    return email;
  }

  void toggleNewPasswordVisibility() {
    emit(ResetPasswordUpdatedState(
      isNewPasswordObscured: !state.isNewPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
      passwordStrength: state.passwordStrength,
      isLengthValid: state.isLengthValid,
      hasNumber: state.hasNumber,
      hasSpecialChar: state.hasSpecialChar,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    emit(ResetPasswordUpdatedState(
      isNewPasswordObscured: state.isNewPasswordObscured,
      isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
      passwordStrength: state.passwordStrength,
      isLengthValid: state.isLengthValid,
      hasNumber: state.hasNumber,
      hasSpecialChar: state.hasSpecialChar,
    ));
  }

  void onNewPasswordChanged(String password) {
    final isLengthValid = password.length >= 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);

    double strength = 0.0;
    if (isLengthValid) strength += 0.34;
    if (hasNumber) strength += 0.33;
    if (hasSpecialChar) strength += 0.33;

    emit(ResetPasswordUpdatedState(
      isNewPasswordObscured: state.isNewPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
      passwordStrength: strength,
      isLengthValid: isLengthValid,
      hasNumber: hasNumber,
      hasSpecialChar: hasSpecialChar,
    ));
  }

  Future<void> resetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(ResetPasswordLoadingState(
      isNewPasswordObscured: state.isNewPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
      passwordStrength: state.passwordStrength,
      isLengthValid: state.isLengthValid,
      hasNumber: state.hasNumber,
      hasSpecialChar: state.hasSpecialChar,
    ));

    final targetEmail = effectiveEmail;
    final result = await _repo.resetPassword(
      ResetPasswordRequestBody(
        email: targetEmail,
        resetToken: resetToken,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );

    result.fold(
      (failure) {
        emit(ResetPasswordErrorState(
          message: failure.message,
          isNewPasswordObscured: state.isNewPasswordObscured,
          isConfirmPasswordObscured: state.isConfirmPasswordObscured,
          passwordStrength: state.passwordStrength,
          isLengthValid: state.isLengthValid,
          hasNumber: state.hasNumber,
          hasSpecialChar: state.hasSpecialChar,
        ));
      },
      (response) {
        emit(ResetPasswordSuccessState(
          response: response,
          isNewPasswordObscured: state.isNewPasswordObscured,
          isConfirmPasswordObscured: state.isConfirmPasswordObscured,
          passwordStrength: state.passwordStrength,
          isLengthValid: state.isLengthValid,
          hasNumber: state.hasNumber,
          hasSpecialChar: state.hasSpecialChar,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
