import 'package:dartz/dartz.dart';
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

  Future<Either<Failure, LoginResponseModel>> login(
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
          AppConstants.userIdKey,
          responseModel.data!.user.id,
        );
        await _sharedPrefService.setString(
          AppConstants.userRoleKey,
          responseModel.data!.user.role,
        );
        await _sharedPrefService.setString(
          AppConstants.userFullNameKey,
          responseModel.data!.user.fullName,
        );
        await _sharedPrefService.setString(
          AppConstants.userEmailKey,
          responseModel.data!.user.email,
        );
        if (responseModel.data!.user.avatarUrl != null &&
            responseModel.data!.user.avatarUrl!.isNotEmpty) {
          await _sharedPrefService.setString(
            AppConstants.userAvatarUrlKey,
            responseModel.data!.user.avatarUrl!,
          );
        }
      }
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في تسجيل الدخول')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
