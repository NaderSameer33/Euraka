import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/caching/secure_storage_service.dart';
import '../../../../../core/caching/shared_pref_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/verify_email_request_body.dart';
import '../models/verify_email_response_model.dart';

class OtpRepo {
  final ApiService _apiService;
  final SecureStorageService _secureStorageService;
  final SharedPrefService _sharedPrefService;

  OtpRepo(
    this._apiService,
    this._secureStorageService,
    this._sharedPrefService,
  );

  Future<Either<Failure, VerifyEmailResponseModel>> verifyEmail(
    VerifyEmailRequestBody body, {
    String? token,
  }) async {
    try {
      final authToken = token ?? await _secureStorageService.read(AppConstants.userTokenKey);
      final headers = <String, dynamic>{};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final res = await _apiService.post(
        endpoint: '/auth/verify-email',
        data: body.toJson(),
        headers: headers,
      );

      final responseModel = VerifyEmailResponseModel.fromJson(res.data as Map<String, dynamic>);
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'رمز التحقق غير صحيح أو انتهت صلاحيته')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/verify-otp',
        data: {
          'email': email,
          'otpCode': otpCode,
        },
      );
      return Right(res.data);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'الرمز غير صحيح أو انتهت صلاحيته. حاول مرة أخرى')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> resendVerificationEmail({
    String? token,
  }) async {
    try {
      final authToken = token ?? await _secureStorageService.read(AppConstants.userTokenKey);
      final headers = <String, dynamic>{};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final res = await _apiService.post(
        endpoint: '/auth/send-verification-email',
        headers: headers,
      );
      return Right(res.data);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في إعادة إرسال الرمز')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> resendForgotPasswordOtp({
    required String email,
  }) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/forgot-password',
        data: {'email': email},
      );
      return Right(res.data);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في إعادة إرسال الرمز')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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

