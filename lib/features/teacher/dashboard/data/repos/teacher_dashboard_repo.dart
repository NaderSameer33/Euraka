import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/caching/secure_storage_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/teacher_dashboard_response_model.dart';

class TeacherDashboardRepo {
  final ApiService _apiService;
  final SecureStorageService _secureStorageService;

  TeacherDashboardRepo(
    this._apiService,
    this._secureStorageService,
  );

  Future<Either<Failure, TeacherDashboardResponseModel>> getDashboardData({
    String? token,
  }) async {
    try {
      final authToken = token ?? await _secureStorageService.read(AppConstants.userTokenKey);
      final headers = <String, dynamic>{};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final res = await _apiService.get(
        endpoint: '/teacher/dashboard',
        headers: headers,
      );

      final responseModel = TeacherDashboardResponseModel.fromJson(res.data as Map<String, dynamic>);
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في جلب بيانات لوحة التحكم')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
