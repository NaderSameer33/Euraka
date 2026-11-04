abstract class OnboardingState {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({
    required this.currentPage,
    required this.isLastPage,
  });
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

