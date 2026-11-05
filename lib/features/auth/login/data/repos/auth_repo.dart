import 'package:dio/dio.dart';
import '../../../../../core/caching/secure_storage_service.dart';
import '../../../../../core/caching/shared_pref_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/login_request_body.dart';
import '../models/login_response_model.dart';

class AuthRepo {
  final ApiService _apiService;
  final SecureStorageService _secureStorageService;
  final SharedPrefService _sharedPrefService;

  AuthRepo(
    this._apiService,
    this._secureStorageService,
    this._sharedPrefService,
  );

  Future<({Failure? failure, LoginResponseModel? response})> login(
    LoginRequestBody body,
  ) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/login',
        data: body.toJson(),
      );
      final responseModel = LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
      if (responseModel.data != null) {
        await _secureStorageService.write(
          AppConstants.userTokenKey,
          responseModel.data!.token,
        );
        if (responseModel.data!.refreshToken != null) {
          await _secureStorageService.write(
            AppConstants.userRefreshTokenKey,
            responseModel.data!.refreshToken!,
          );
        }
        await _sharedPrefService.setString(
          AppConstants.userRoleKey,
          responseModel.data!.user.role,
        );
      }
      return (failure: null, response: responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في تسجيل الدخول')
          : 'حدث خطأ في الاتصال بالخادم';
      return (
        failure: ServerFailure(message, e.response?.statusCode),
        response: null,
      );
    } catch (e) {
      return (
        failure: ServerFailure(e.toString()),
        response: null,
      );
    }
  }
}
