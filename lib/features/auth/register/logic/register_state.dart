import 'package:equatable/equatable.dart';
import '../data/models/register_response_model.dart';

abstract class RegisterState extends Equatable {
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;

  const RegisterState({
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  @override
  List<Object?> get props => [isPasswordObscured, isConfirmPasswordObscured];
}

class RegisterInitialState extends RegisterState {
  const RegisterInitialState({
    super.isPasswordObscured,
    super.isConfirmPasswordObscured,
  });
}

class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState({
    super.isPasswordObscured,
    super.isConfirmPasswordObscured,
  });
}

class RegisterSuccessState extends RegisterState {
  final RegisterResponseModel response;

  const RegisterSuccessState({
    required this.response,
    super.isPasswordObscured,
    super.isConfirmPasswordObscured,
  });

  @override
  List<Object?> get props => [response, isPasswordObscured, isConfirmPasswordObscured];
}

class RegisterErrorState extends RegisterState {
  final String message;

  const RegisterErrorState({
    required this.message,
    super.isPasswordObscured,
    super.isConfirmPasswordObscured,
  });

  @override
  List<Object?> get props => [message, isPasswordObscured, isConfirmPasswordObscured];
}

