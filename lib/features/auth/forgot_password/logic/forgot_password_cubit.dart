import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router_name.dart';
import '../data/models/forgot_password_request_body.dart';
import '../data/repos/forgot_password_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends SafeCubit<ForgotPasswordState> {
  final ForgotPasswordRepo _repo;
  final SharedPrefService _sharedPrefService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordCubit(
    this._repo,
    this._sharedPrefService,
  ) : super(const ForgotPasswordInitialState());

  Future<void> sendResetCode(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(const ForgotPasswordLoadingState());

    final email = emailController.text.trim();
    final result = await _repo.forgotPassword(
      ForgotPasswordRequestBody(email: email),
    );

    await result.fold(
      (failure) async {
        emit(ForgotPasswordErrorState(message: failure.message));
      },
      (response) async {
        await _sharedPrefService.setString(AppConstants.userEmailKey, email);
        emit(ForgotPasswordSuccessState(response: response));
        if (context.mounted) {
          context.push(
            AppRouterName.otp,
            extra: {
              'email': email,
              'isForgotPassword': true,
            },
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
