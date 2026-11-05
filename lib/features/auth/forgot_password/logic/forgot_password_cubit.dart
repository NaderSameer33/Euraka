import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/forgot_password_request_body.dart';
import '../data/repos/forgot_password_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends SafeCubit<ForgotPasswordState> {
  final ForgotPasswordRepo _repo;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordCubit({ForgotPasswordRepo? repo})
      : _repo = repo ?? getIt<ForgotPasswordRepo>(),
        super(const ForgotPasswordInitialState());

  Future<void> sendResetCode(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(const ForgotPasswordLoadingState());

    final email = emailController.text.trim();
    final result = await _repo.forgotPassword(
      ForgotPasswordRequestBody(email: email),
    );

    if (result.failure != null) {
      emit(ForgotPasswordErrorState(message: result.failure!.message));
    } else if (result.response != null) {
      await getIt<SharedPrefService>().setString(AppConstants.userEmailKey, email);
      emit(ForgotPasswordSuccessState(response: result.response!));
      if (context.mounted) {
        context.push(
          AppRouterName.otp,
          extra: {
            'email': email,
            'isForgotPassword': true,
          },
        );
      }
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}

