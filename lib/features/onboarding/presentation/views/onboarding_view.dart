import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/onboarding_bottom_bar.dart';
import '../components/onboarding_page_item.dart';
import '../components/onboarding_top_bar.dart';
import '../../logic/onboarding_cubit.dart';
import '../../logic/onboarding_state.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const _OnboardingViewBody(),
    );
  }
}

class _OnboardingViewBody extends StatelessWidget {
  const _OnboardingViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                OnboardingTopBar(
                  isLastPage: state.isLastPage,
                  onSkip: () => cubit.completeOnboarding(context),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: cubit.items.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingPageItem(
                        item: cubit.items[index],
                      );
                    },
                  ),
                ),
                OnboardingBottomBar(
                  totalCount: cubit.items.length,
                  currentIndex: state.currentPage,
                  isLastPage: state.isLastPage,
                  onNext: cubit.nextPage,
                  onGetStarted: () => cubit.completeOnboarding(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
