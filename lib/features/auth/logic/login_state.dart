import 'package:equatable/equatable.dart';
import '../data/models/login_response_model.dart';

abstract class LoginState extends Equatable {
  final bool isPasswordObscured;

  const LoginState({this.isPasswordObscured = true});

  @override
  List<Object?> get props => [isPasswordObscured];
}

class LoginInitialState extends LoginState {
  const LoginInitialState({super.isPasswordObscured});
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState({super.isPasswordObscured});
}

class LoginSuccessState extends LoginState {
  final LoginResponseModel response;

  const LoginSuccessState({
    required this.response,
    super.isPasswordObscured,
  });

  @override
  List<Object?> get props => [response, isPasswordObscured];
}

class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState({
    required this.message,
    super.isPasswordObscured,
  });

  @override
  List<Object?> get props => [message, isPasswordObscured];
}

