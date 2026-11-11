import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/create_homework_request_body.dart';
import '../models/teacher_homework_model.dart';

class TeacherHomeworkRepo {
  final ApiService _apiService;

  TeacherHomeworkRepo(this._apiService);

  Future<Either<Failure, TeacherHomeworkModel>> createHomework(
    CreateHomeworkRequestBody body,
  ) async {
    try {
      final res = await _apiService.post(
        endpoint: '/teacher/homework',
        data: body.toJson(),
      );
      final data = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      if (data != null) {
        return Right(TeacherHomeworkModel.fromJson(data));
      }
      return Right(
        TeacherHomeworkModel(
          id: '',
          groupId: body.groupId,
          title: body.title,
          unitName: body.unitName,
          durationMinutes: body.durationMinutes,
          totalScore: body.questions.fold(0, (sum, q) => sum + q.score),
          dueDate: body.dueDate,
          questionsCount: body.questions.length,
          questions: body.questions,
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء إنشاء الواجب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<TeacherHomeworkModel>>> getHomeworks({String? groupId}) async {
    try {
      final endpoint = groupId != null && groupId.isNotEmpty
          ? '/teacher/homework?groupId=$groupId'
          : '/teacher/homework';
      final res = await _apiService.get(endpoint: endpoint);
      final dataObj = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      final rawList = dataObj != null && dataObj['homeworks'] is List
          ? (dataObj['homeworks'] as List<dynamic>)
          : (res.data is List ? (res.data as List<dynamic>) : <dynamic>[]);

      final list = rawList
          .map((e) => TeacherHomeworkModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب الواجبات')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherHomeworkModel>> getHomeworkDetails(String id) async {
    try {
      if (id.trim().isEmpty) {
        return const Left(ServerFailure('معرف الواجب غير صالح'));
      }
      final res = await _apiService.get(endpoint: '/teacher/homework/$id');
      final data = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      if (data != null) {
        return Right(TeacherHomeworkModel.fromJson(data));
      }
      return const Left(ServerFailure('تعذر جلب تفاصيل الواجب'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب تفاصيل الواجب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<dynamic>>> getHomeworkSubmissions(String id) async {
    try {
      if (id.trim().isEmpty) {
        return const Right([]);
      }
      final res = await _apiService.get(endpoint: '/teacher/homework/$id/submissions');
      final data = res.data is Map ? (res.data['data'] as List<dynamic>?) : null;
      return Right(data ?? []);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب تسليمات الواجب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteHomework(String id) async {
    try {
      final res = await _apiService.delete(endpoint: '/teacher/homework/$id');
      final message = res.data is Map
          ? (res.data['message'] as String? ?? 'تم حذف الواجب بنجاح')
          : 'تم حذف الواجب بنجاح';
      return Right(message);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء حذف الواجب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
