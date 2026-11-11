import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../features/teacher/chat/data/models/teacher_conversation_model.dart';
import '../../features/teacher/chat/presentation/views/teacher_chat_view.dart';
import '../../features/teacher/chat/presentation/views/teacher_communication_hub_view.dart';
import '../../features/teacher/chat/presentation/views/teacher_inbox_view.dart';
import '../../features/teacher/dashboard/presentation/views/teacher_dashboard_view.dart';
import '../../features/teacher/groups/data/models/teacher_student_details_model.dart';
import '../../features/teacher/groups/presentation/views/teacher_add_group_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_add_student_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_edit_student_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_group_students_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_groups_view.dart';
import '../../features/teacher/groups/presentation/views/teacher_student_details_view.dart';
import '../../features/teacher/homework/logic/create_homework_cubit.dart';
import '../../features/teacher/homework/logic/teacher_homework_list_cubit.dart';
import '../../features/teacher/homework/presentation/views/teacher_create_homework_view.dart';
import '../../features/teacher/homework/presentation/views/teacher_homework_details_view.dart';
import '../../features/teacher/homework/presentation/views/teacher_homework_list_view.dart';
import '../../features/teacher/lessons/presentation/views/teacher_add_lesson_material_view.dart';
import '../../features/teacher/lessons/presentation/views/teacher_add_lesson_video_view.dart';
import '../../features/teacher/lessons/presentation/views/teacher_add_lesson_view.dart';
import '../../features/teacher/lessons/presentation/views/teacher_lesson_details_view.dart';
import '../../features/teacher/lessons/presentation/views/teacher_lesson_video_details_view.dart';
import '../../features/teacher/main/presentation/views/teacher_main_view.dart';
import '../../features/teacher/main/presentation/views/teacher_tab_placeholder_view.dart';
import '../../features/teacher/subjects/presentation/views/teacher_add_subject_view.dart';
import '../../features/teacher/subjects/presentation/views/teacher_add_unit_view.dart';
import '../../features/teacher/subjects/presentation/views/teacher_subject_units_view.dart';
import '../../features/teacher/subjects/presentation/views/teacher_subjects_view.dart';
import '../../features/teacher/subjects/presentation/views/teacher_unit_details_view.dart';
import '../../features/teacher/tasks/presentation/views/teacher_tasks_view.dart';
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
                builder: (context, state) => const TeacherSubjectsView(),
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
                builder: (context, state) => const TeacherTasksView(),
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
        path: AppRouterName.teacherAddSubject,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const TeacherAddSubjectView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherSubjectUnits,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final subjectId = extra?['subjectId'] as String? ?? '';
          final gradeLevelId = extra?['gradeLevelId'] as String?;
          final subjectName = extra?['subjectName'] as String? ?? 'المادة الدراسية';
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherSubjectUnitsView(
              subjectId: subjectId,
              gradeLevelId: gradeLevelId,
              initialSubjectName: subjectName,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherAddUnit,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final subjectId = extra?['subjectId'] as String?;
          final subjectName = extra?['subjectName'] as String?;
          final gradeLevelId = extra?['gradeLevelId'] as String?;
          final nextUnitNumber = extra?['nextUnitNumber'] as int?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherAddUnitView(
              initialSubjectId: subjectId,
              initialSubjectName: subjectName,
              initialGradeLevelId: gradeLevelId,
              initialUnitNumber: nextUnitNumber,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherUnitDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final unitId = extra?['unitId'] as String? ?? '';
          final title = extra?['title'] as String? ?? extra?['name'] as String?;
          final subjectName = extra?['subjectName'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherUnitDetailsView(
              unitId: unitId,
              initialTitle: title,
              initialSubjectName: subjectName,
            ),
          );
        },
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
        path: AppRouterName.teacherStudentDetails,
        pageBuilder: (context, state) {
          String studentId = '';
          String? groupId;
          String? groupName;
          bool? isPaid;
          String? paymentStatus;

          if (state.extra is String) {
            studentId = state.extra as String;
          } else if (state.extra is Map) {
            final extra = Map<String, dynamic>.from(state.extra as Map);
            studentId = extra['studentId'] as String? ?? '';
            groupId = extra['groupId'] as String?;
            groupName = extra['groupName'] as String?;
            isPaid = extra['isPaid'] as bool?;
            paymentStatus = extra['paymentStatus'] as String?;
          }

          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherStudentDetailsView(
              studentId: studentId,
              groupId: groupId,
              groupName: groupName,
              isPaid: isPaid,
              paymentStatus: paymentStatus,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherEditStudent,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final studentId = extra?['studentId'] as String? ?? '';
          final initialData = extra?['initialData'] as TeacherStudentDetailsData?;
          final groupId = extra?['groupId'] as String?;
          final groupName = extra?['groupName'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherEditStudentView(
              studentId: studentId,
              initialData: initialData,
              groupId: groupId,
              groupName: groupName,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherLessonDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final lessonId = extra?['lessonId'] as String? ?? '';
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherLessonDetailsView(
              lessonId: lessonId,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherAddLesson,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final subjectId = extra?['subjectId'] as String?;
          final unitId = extra?['unitId'] as String?;
          final nextOrder = extra?['nextOrder'] as int?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherAddLessonView(
              initialSubjectId: subjectId,
              initialUnitId: unitId,
              initialLessonOrder: nextOrder,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherLessonVideoDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final videoId = extra?['videoId'] as String? ?? '';
          final title = extra?['title'] as String? ?? extra?['name'] as String?;
          final breadcrumb = extra?['breadcrumb'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherLessonVideoDetailsView(
              videoId: videoId,
              initialName: title,
              initialBreadcrumb: breadcrumb,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherAddLessonVideo,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final lessonId = extra?['lessonId'] as String? ?? '';
          final breadcrumb = extra?['breadcrumb'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherAddLessonVideoView(
              lessonId: lessonId,
              breadcrumb: breadcrumb,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherAddLessonMaterial,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final lessonId = extra?['lessonId'] as String? ?? '';
          final breadcrumb = extra?['breadcrumb'] as String?;
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherAddLessonMaterialView(
              lessonId: lessonId,
              breadcrumb: breadcrumb,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherHomeworkList,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => getIt<TeacherHomeworkListCubit>(),
            child: const TeacherHomeworkListView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherHomeworkDetails,
        pageBuilder: (context, state) {
          String homeworkId = '';
          if (state.extra is String) {
            homeworkId = state.extra as String;
          } else if (state.extra is Map) {
            final map = state.extra as Map<String, dynamic>;
            homeworkId = map['homeworkId'] as String? ?? map['id'] as String? ?? '';
          }
          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherHomeworkDetailsView(homeworkId: homeworkId),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.teacherCreateHomework,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => getIt<CreateHomeworkCubit>(),
            child: const TeacherCreateHomeworkView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherCommunicationHub,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const TeacherCommunicationHubView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherInbox,
        pageBuilder: (context, state) => buildSmoothTransitionPage(
          context: context,
          state: state,
          child: const TeacherInboxView(),
        ),
      ),
      GoRoute(
        path: AppRouterName.teacherChat,
        pageBuilder: (context, state) {
          String conversationId = '';
          TeacherConversationModel? conversation;

          if (state.extra is TeacherConversationModel) {
            conversation = state.extra as TeacherConversationModel;
            conversationId = conversation.id;
          } else if (state.extra is String) {
            conversationId = state.extra as String;
          } else if (state.extra is Map) {
            final map = Map<String, dynamic>.from(state.extra as Map);
            conversationId = map['conversationId'] as String? ?? map['id'] as String? ?? '';
            if (map['conversation'] is TeacherConversationModel) {
              conversation = map['conversation'] as TeacherConversationModel;
            }
          }

          return buildSmoothTransitionPage(
            context: context,
            state: state,
            child: TeacherChatView(
              conversationId: conversationId,
              conversation: conversation,
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
