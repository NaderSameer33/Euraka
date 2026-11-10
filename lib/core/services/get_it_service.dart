import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/forgot_password/data/repos/forgot_password_repo.dart';
import '../../features/auth/forgot_password/logic/forgot_password_cubit.dart';
import '../../features/auth/login/data/repos/auth_repo.dart';
import '../../features/auth/login/logic/login_cubit.dart';
import '../../features/auth/otp/data/repos/otp_repo.dart';
import '../../features/auth/otp/logic/otp_cubit.dart';
import '../../features/auth/register/data/repos/register_repo.dart';
import '../../features/auth/register/logic/register_cubit.dart';
import '../../features/auth/reset_password/data/repos/reset_password_repo.dart';
import '../../features/auth/reset_password/logic/reset_password_cubit.dart';
import '../../features/onboarding/data/repos/onboarding_repo.dart';
import '../../features/onboarding/logic/onboarding_cubit.dart';
import '../../features/role_selection/data/repos/role_selection_repo.dart';
import '../../features/role_selection/logic/role_selection_cubit.dart';
import '../../features/teacher/dashboard/data/repos/teacher_dashboard_repo.dart';
import '../../features/teacher/dashboard/logic/teacher_dashboard_cubit.dart';
import '../../features/teacher/groups/data/models/teacher_student_details_model.dart';
import '../../features/teacher/groups/data/repos/teacher_groups_repo.dart';
import '../../features/teacher/groups/logic/add_group_cubit.dart';
import '../../features/teacher/groups/logic/add_student_cubit.dart';
import '../../features/teacher/groups/logic/group_students_cubit.dart';
import '../../features/teacher/groups/logic/teacher_edit_student_cubit.dart';
import '../../features/teacher/groups/logic/teacher_groups_cubit.dart';
import '../../features/teacher/groups/logic/teacher_student_details_cubit.dart';
import '../../features/teacher/lessons/data/repos/teacher_lessons_repo.dart';
import '../../features/teacher/subjects/data/repos/teacher_subjects_repo.dart';
import '../../features/teacher/subjects/logic/add_subject_cubit.dart';
import '../../features/teacher/subjects/logic/teacher_subjects_cubit.dart';
import '../caching/secure_storage_service.dart';
import '../caching/shared_pref_service.dart';
import '../theme/logic/theme_cubit.dart';
import 'api_service.dart';
import 'auth_interceptor.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<SharedPrefService>(() => SharedPrefService(getIt<SharedPreferences>()));

  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService(getIt<FlutterSecureStorage>()));

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() {
    final dio = getIt<Dio>();
    dio.interceptors.addAll([
      AuthInterceptor(
        dio: dio,
        secureStorageService: getIt<SecureStorageService>(),
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
    return ApiService(dio);
  });

  getIt.registerSingleton<ThemeCubit>(ThemeCubit(getIt<SharedPrefService>()));

  getIt.registerLazySingleton<OnboardingRepo>(
    () => OnboardingRepo(),
  );

  getIt.registerLazySingleton<RoleSelectionRepo>(
    () => RoleSelectionRepo(getIt<SharedPrefService>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(
      getIt<ApiService>(),
      getIt<SecureStorageService>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(
      getIt<ApiService>(),
      getIt<SecureStorageService>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerLazySingleton<OtpRepo>(
    () => OtpRepo(
      getIt<ApiService>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ResetPasswordRepo>(
    () => ResetPasswordRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<TeacherDashboardRepo>(
    () => TeacherDashboardRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<TeacherGroupsRepo>(
    () => TeacherGroupsRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<TeacherSubjectsRepo>(
    () => TeacherSubjectsRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<TeacherLessonsRepo>(
    () => TeacherLessonsRepo(getIt<ApiService>()),
  );

  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      getIt<OnboardingRepo>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerFactory<RoleSelectionCubit>(
    () => RoleSelectionCubit(getIt<RoleSelectionRepo>()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<AuthRepo>()),
  );

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterRepo>()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      getIt<ForgotPasswordRepo>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerFactoryParam<ResetPasswordCubit, ({String email, String? resetToken}), void>(
    (param, _) => ResetPasswordCubit(
      getIt<ResetPasswordRepo>(),
      getIt<SharedPrefService>(),
      email: param.email,
      resetToken: param.resetToken,
    ),
  );

  getIt.registerFactoryParam<OtpCubit, ({String email, String? token, bool isForgotPassword}), void>(
    (param, _) => OtpCubit(
      getIt<OtpRepo>(),
      getIt<SharedPrefService>(),
      email: param.email,
      token: param.token,
      isForgotPassword: param.isForgotPassword,
    ),
  );

  getIt.registerFactory<TeacherDashboardCubit>(
    () => TeacherDashboardCubit(
      getIt<TeacherDashboardRepo>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerFactory<TeacherGroupsCubit>(
    () => TeacherGroupsCubit(
      getIt<TeacherGroupsRepo>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerFactory<TeacherSubjectsCubit>(
    () => TeacherSubjectsCubit(
      getIt<TeacherSubjectsRepo>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerFactory<AddSubjectCubit>(
    () => AddSubjectCubit(
      getIt<TeacherSubjectsRepo>(),
    ),
  );

  getIt.registerFactory<AddGroupCubit>(
    () => AddGroupCubit(
      getIt<TeacherGroupsRepo>(),
      getIt<SharedPrefService>(),
      getIt<SecureStorageService>(),
    ),
  );

  getIt.registerFactoryParam<GroupStudentsCubit, ({String groupId, String groupName}), void>(
    (param, _) => GroupStudentsCubit(
      getIt<TeacherGroupsRepo>(),
      groupId: param.groupId,
      initialGroupName: param.groupName,
    ),
  );

  getIt.registerFactoryParam<AddStudentCubit, ({String groupId, int defaultPrice}), void>(
    (param, _) => AddStudentCubit(
      getIt<TeacherGroupsRepo>(),
      getIt<SharedPrefService>(),
      getIt<SecureStorageService>(),
      groupId: param.groupId,
      defaultPrice: param.defaultPrice,
    ),
  );

  getIt.registerFactoryParam<TeacherStudentDetailsCubit, ({String studentId, String? groupName, bool? isPaid, String? paymentStatus}), void>(
    (param, _) => TeacherStudentDetailsCubit(
      getIt<TeacherGroupsRepo>(),
      studentId: param.studentId,
      initialGroupName: param.groupName,
      currentIsPaid: param.isPaid,
      currentPaymentStatus: param.paymentStatus,
    ),
  );

  getIt.registerFactoryParam<TeacherEditStudentCubit, ({String studentId, TeacherStudentDetailsData? initialData, String? initialGroupId, String? initialGroupName}), void>(
    (param, _) => TeacherEditStudentCubit(
      getIt<TeacherGroupsRepo>(),
      studentId: param.studentId,
      initialData: param.initialData,
      initialGroupId: param.initialGroupId,
      initialGroupName: param.initialGroupName,
    ),
  );
}
