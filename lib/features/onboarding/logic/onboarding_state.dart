import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({
    required this.currentPage,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [currentPage, isLastPage];
}

class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState()
      : super(
          currentPage: 0,
          isLastPage: false,
        );
}

class OnboardingPageChangedState extends OnboardingState {
  const OnboardingPageChangedState({
    required super.currentPage,
    required super.isLastPage,
  });
}
