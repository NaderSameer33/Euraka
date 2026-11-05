import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/register/presentation/views/register_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/role_selection/presentation/views/role_selection_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import 'app_router_name.dart';
import 'smooth_page_transition.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRouterName.splash,
    routes: [
      GoRoute(
        path: AppRouterName.splash,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const SplashView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.onboarding,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.roleSelection,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const RoleSelectionView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.login,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.register,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const RegisterView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherHome,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Teacher Home Dashboard'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRouterName.studentHome,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Student Home Dashboard'),
            ),
          ),
        ),
      ),
    ],
  );
}
