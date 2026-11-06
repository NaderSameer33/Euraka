import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router_name.dart';
import '../data/models/onboarding_item_model.dart';
import '../data/repos/onboarding_repo.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends SafeCubit<OnboardingState> {
  final OnboardingRepo _repo;
  final SharedPrefService _sharedPrefService;
  final PageController pageController = PageController();

  late final List<OnboardingItemModel> items;

  OnboardingCubit(
    this._repo,
    this._sharedPrefService,
  ) : super(const OnboardingInitialState()) {
    items = _repo.getOnboardingItems();
  }

  void onPageChanged(int index) {
    emit(
      OnboardingPageChangedState(
        currentPage: index,
        isLastPage: index == items.length - 1,
      ),
    );
  }

  void nextPage() {
    if (state.currentPage < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    await _sharedPrefService.setBool(AppConstants.isOnboardingCompletedKey, true);
    if (context.mounted) {
      context.go(AppRouterName.login);
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
