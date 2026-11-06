import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/login_request_body.dart';
import '../data/repos/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends SafeCubit<LoginState> {
  final AuthRepo _authRepo;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginCubit({AuthRepo? authRepo})
      : _authRepo = authRepo ?? getIt<AuthRepo>(),
        super(const LoginInitialState());

  void togglePasswordVisibility() {
    final next = !state.isPasswordObscured;
    if (state is LoginLoadingState) {
      emit(LoginLoadingState(isPasswordObscured: next));
    } else if (state is LoginErrorState) {
      emit(LoginErrorState(
        message: (state as LoginErrorState).message,
        isPasswordObscured: next,
      ));
    } else if (state is LoginSuccessState) {
      emit(LoginSuccessState(
        response: (state as LoginSuccessState).response,
        isPasswordObscured: next,
      ));
    } else {
      emit(LoginInitialState(isPasswordObscured: next));
    }
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoadingState(isPasswordObscured: state.isPasswordObscured));

    final result = await _authRepo.login(
      LoginRequestBody(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );

    result.fold(
      (failure) {
        emit(
          LoginErrorState(
            message: failure.message,
            isPasswordObscured: state.isPasswordObscured,
          ),
        );
      },
      (response) {
        emit(
          LoginSuccessState(
            response: response,
            isPasswordObscured: state.isPasswordObscured,
          ),
        );
        if (context.mounted) {
          final role = response.data?.user.role.toUpperCase();
          if (role == 'TEACHER') {
            context.go(AppRouterName.teacherHome);
          } else {
            context.go(AppRouterName.studentHome);
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
