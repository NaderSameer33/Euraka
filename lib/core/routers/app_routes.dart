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
import '../../features/teacher/dashboard/presentation/views/teacher_dashboard_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_add_group_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_add_student_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_group_students_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_groups_view.dart';
import '../../features/teacher/main/presentation/views/teacher_main_view.dart';
import '../../features/teacher/main/presentation/views/teacher_tab_placeholder_view.dart';
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TeacherMainView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterName.teacherGroups,
                builder: (context, state) => const TeacherGroupsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterName.teacherSubjects,
                builder: (context, state) => const TeacherTabPlaceholderView(
                  title: 'المواد',
                  icon: Icons.menu_book_rounded,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterName.teacherHome,
                builder: (context, state) => const TeacherDashboardView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterName.teacherTasks,
                builder: (context, state) => const TeacherTabPlaceholderView(
                  title: 'المهام',
                  icon: Icons.task_alt_rounded,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouterName.teacherWallet,
                builder: (context, state) => const TeacherTabPlaceholderView(
                  title: 'المالية',
                  icon: Icons.account_balance_wallet_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRouterName.teacherAddGroup,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const TeacherAddGroupView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherGroupStudents,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final groupId = extra?['groupId'] as String? ?? '';
          final groupName = extra?['groupName'] as String? ?? 'المجموعة';
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherGroupStudentsView(
              groupId: groupId,
              groupName: groupName,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherAddStudent,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final groupId = extra?['groupId'] as String? ?? '';
          final groupName = extra?['groupName'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherAddStudentView(
              groupId: groupId,
              groupName: groupName,
            ),
          );
        },
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
