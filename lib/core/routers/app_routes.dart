import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../caching/shared_pref_service.dart';
import '../constants/app_constants.dart';
import '../services/get_it_service.dart';
import '../../features/auth/forgot_password/presentation/views/forgot_password_view.dart';
import '../../features/auth/login/presentation/views/login_view.dart';
import '../../features/auth/otp/presentation/views/otp_view.dart';
import '../../features/auth/register/presentation/views/register_view.dart';
import '../../features/auth/reset_password/presentation/views/reset_password_view.dart';
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
        path: AppRouterName.forgotPassword,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const ForgotPasswordView(),
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
        path: AppRouterName.otp,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final cachedEmail = getIt<SharedPrefService>().getString(AppConstants.userEmailKey);
          final email = extra?['email'] as String? ?? cachedEmail ?? 'student.journey@eureka-test.com';
          final token = extra?['token'] as String?;
          final isForgotPassword = extra?['isForgotPassword'] as bool? ?? (token == null);
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: OtpView(
              email: email,
              token: token,
              isForgotPassword: isForgotPassword,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.resetPassword,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final cachedEmail = getIt<SharedPrefService>().getString(AppConstants.userEmailKey);
          final email = extra?['email'] as String? ?? cachedEmail ?? 'student.journey@eureka-test.com';
          final resetToken = extra?['resetToken'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: ResetPasswordView(
              email: email,
              resetToken: resetToken,
            ),
          );
        },
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
