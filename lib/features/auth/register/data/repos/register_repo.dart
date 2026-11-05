import 'package:dio/dio.dart';
import '../../../../../core/caching/secure_storage_service.dart';
import '../../../../../core/caching/shared_pref_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/register_request_body.dart';
import '../models/register_response_model.dart';

class RegisterRepo {
  final ApiService _apiService;
  final SecureStorageService _secureStorageService;
  final SharedPrefService _sharedPrefService;

  RegisterRepo(
    this._apiService,
    this._secureStorageService,
    this._sharedPrefService,
  );

  Future<({Failure? failure, RegisterResponseModel? response})> register(
    RegisterRequestBody body,
  ) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/register',
        data: body.toJson(),
      );
      final responseModel = RegisterResponseModel.fromJson(res.data as Map<String, dynamic>);
      if (responseModel.data != null) {
        if (responseModel.data!.token != null) {
          await _secureStorageService.write(
            AppConstants.userTokenKey,
            responseModel.data!.token!,
          );
        }
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
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في إنشاء الحساب')
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

  String getSavedRole() {
    final saved = _sharedPrefService.getString(AppConstants.userRoleKey);
    if (saved != null && saved.toLowerCase().contains('student')) {
      return 'STUDENT';
    }
    return 'TEACHER';
  }
}

