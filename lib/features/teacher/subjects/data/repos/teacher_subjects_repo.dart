import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../../../groups/data/models/academic_stage_model.dart';
import '../../../groups/data/models/teacher_groups_response_model.dart';
import '../models/create_subject_request_body.dart';
import '../models/create_subject_response_model.dart';
import '../models/teacher_subjects_response_model.dart';

class TeacherSubjectsRepo {
  final ApiService _apiService;

  TeacherSubjectsRepo(this._apiService);

  Future<Either<Failure, TeacherSubjectsResponseModel>> getSubjects() async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/subjects');
      final responseModel = TeacherSubjectsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب المواد الدراسية')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, CreateSubjectResponseModel>> createSubject(
    CreateSubjectRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final res = await _apiService.post(
        endpoint: '/teacher/subjects',
        data: formData,
      );
      final responseModel = CreateSubjectResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء إضافة المادة الدراسية')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AcademicStageResponseModel>> getStages() async {
    try {
      final res = await _apiService.get(endpoint: '/academic/stages');
      final responseModel = AcademicStageResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب المراحل الدراسية')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherGroupsResponseModel>> getGroups() async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/groups');
      final responseModel = TeacherGroupsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب المجموعات')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
