import 'package:equatable/equatable.dart';
import '../data/models/forgot_password_response_model.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  const ForgotPasswordInitialState();
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  const ForgotPasswordLoadingState();
}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final ForgotPasswordResponseModel response;

  const ForgotPasswordSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
