import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import 'app_router_name.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRouterName.splash,
    routes: [
      GoRoute(
        path: AppRouterName.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRouterName.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRouterName.login,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Login'),
          ),
        ),
      ),
    ],
  );
}
