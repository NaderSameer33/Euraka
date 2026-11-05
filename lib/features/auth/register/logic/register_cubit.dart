import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/register_request_body.dart';
import '../data/repos/register_repo.dart';
import 'register_state.dart';

class RegisterCubit extends SafeCubit<RegisterState> {
  final RegisterRepo _registerRepo;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterCubit({RegisterRepo? registerRepo})
      : _registerRepo = registerRepo ?? getIt<RegisterRepo>(),
        super(const RegisterInitialState());

  void togglePasswordVisibility() {
    final next = !state.isPasswordObscured;
    _emitUpdatedState(isPassword: next, isConfirm: state.isConfirmPasswordObscured);
  }

  void toggleConfirmPasswordVisibility() {
    final next = !state.isConfirmPasswordObscured;
    _emitUpdatedState(isPassword: state.isPasswordObscured, isConfirm: next);
  }

  void _emitUpdatedState({required bool isPassword, required bool isConfirm}) {
    if (state is RegisterLoadingState) {
      emit(RegisterLoadingState(
        isPasswordObscured: isPassword,
        isConfirmPasswordObscured: isConfirm,
      ));
    } else if (state is RegisterErrorState) {
      emit(RegisterErrorState(
        message: (state as RegisterErrorState).message,
        isPasswordObscured: isPassword,
        isConfirmPasswordObscured: isConfirm,
      ));
    } else if (state is RegisterSuccessState) {
      emit(RegisterSuccessState(
        response: (state as RegisterSuccessState).response,
        isPasswordObscured: isPassword,
        isConfirmPasswordObscured: isConfirm,
      ));
    } else {
      emit(RegisterInitialState(
        isPasswordObscured: isPassword,
        isConfirmPasswordObscured: isConfirm,
      ));
    }
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(RegisterLoadingState(
      isPasswordObscured: state.isPasswordObscured,
      isConfirmPasswordObscured: state.isConfirmPasswordObscured,
    ));

    final result = await _registerRepo.register(
      RegisterRequestBody(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        role: _registerRepo.getSavedRole(),
      ),
    );

    if (result.failure != null) {
      emit(
        RegisterErrorState(
          message: result.failure!.message,
          isPasswordObscured: state.isPasswordObscured,
          isConfirmPasswordObscured: state.isConfirmPasswordObscured,
        ),
      );
    } else if (result.response != null) {
      emit(
        RegisterSuccessState(
          response: result.response!,
          isPasswordObscured: state.isPasswordObscured,
          isConfirmPasswordObscured: state.isConfirmPasswordObscured,
        ),
      );
      if (context.mounted) {
        context.push(
          AppRouterName.otp,
          extra: {
            'email': emailController.text.trim(),
            'token': result.response?.data?.token,
          },
        );
      }
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

