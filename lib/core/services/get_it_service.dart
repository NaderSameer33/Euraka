import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/forgot_password/data/repos/forgot_password_repo.dart';
import '../../features/auth/login/data/repos/auth_repo.dart';
import '../../features/auth/otp/data/repos/otp_repo.dart';
import '../../features/auth/register/data/repos/register_repo.dart';
import '../../features/auth/reset_password/data/repos/reset_password_repo.dart';
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
      getIt<SecureStorageService>(),
      getIt<SharedPrefService>(),
    ),
  );

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepo(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ResetPasswordRepo>(
    () => ResetPasswordRepo(getIt<ApiService>()),
  );
}
