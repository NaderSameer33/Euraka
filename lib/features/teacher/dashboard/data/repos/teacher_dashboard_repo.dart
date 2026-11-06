import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/teacher_dashboard_response_model.dart';

class TeacherDashboardRepo {
  final ApiService _apiService;

  TeacherDashboardRepo(this._apiService);

  Future<Either<Failure, TeacherDashboardResponseModel>> getDashboardData() async {
    try {
      final res = await _apiService.get(
        endpoint: '/teacher/dashboard',
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
