import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/reset_password_request_body.dart';
import '../data/repos/reset_password_repo.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends SafeCubit<ResetPasswordState> {
  final ResetPasswordRepo _repo;
  final String email;
  final String? resetToken;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordCubit({
    ResetPasswordRepo? repo,
    required this.email,
    this.resetToken,
  })  : _repo = repo ?? getIt<ResetPasswordRepo>(),
        super(const ResetPasswordInitialState());

  void toggleCurrentPasswordVisibility() {
    emit(ResetPasswordUpdatedState(
      isCurrentPasswordObscured: !state.isCurrentPasswordObscured,
      isNewPasswordObscured: state.isNewPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
      passwordStrength: state.passwordStrength,
      isLengthValid: state.isLengthValid,
      hasNumber: state.hasNumber,
      hasSpecialChar: state.hasSpecialChar,
    ));
  }

  void toggleNewPasswordVisibility() {
    emit(ResetPasswordUpdatedState(
      isCurrentPasswordObscured: state.isCurrentPasswordObscured,
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
      isCurrentPasswordObscured: state.isCurrentPasswordObscured,
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
      isCurrentPasswordObscured: state.isCurrentPasswordObscured,
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
      isCurrentPasswordObscured: state.isCurrentPasswordObscured,
      isNewPasswordObscured: state.isNewPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
      passwordStrength: state.passwordStrength,
      isLengthValid: state.isLengthValid,
      hasNumber: state.hasNumber,
      hasSpecialChar: state.hasSpecialChar,
    ));

    final result = await _repo.resetPassword(
      ResetPasswordRequestBody(
        email: email,
        resetToken: resetToken,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
        currentPassword: currentPasswordController.text.isNotEmpty
            ? currentPasswordController.text
            : null,
      ),
    );

    if (result.failure != null) {
      emit(ResetPasswordErrorState(
        message: result.failure!.message,
        isCurrentPasswordObscured: state.isCurrentPasswordObscured,
        isNewPasswordObscured: state.isNewPasswordObscured,
        isConfirmPasswordObscured: state.isConfirmPasswordObscured,
        passwordStrength: state.passwordStrength,
        isLengthValid: state.isLengthValid,
        hasNumber: state.hasNumber,
        hasSpecialChar: state.hasSpecialChar,
      ));
    } else if (result.response != null) {
      emit(ResetPasswordSuccessState(
        response: result.response!,
        isCurrentPasswordObscured: state.isCurrentPasswordObscured,
        isNewPasswordObscured: state.isNewPasswordObscured,
        isConfirmPasswordObscured: state.isConfirmPasswordObscured,
        passwordStrength: state.passwordStrength,
        isLengthValid: state.isLengthValid,
        hasNumber: state.hasNumber,
        hasSpecialChar: state.hasSpecialChar,
      ));
      if (context.mounted) {
        context.go(AppRouterName.login);
      }
    }
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
