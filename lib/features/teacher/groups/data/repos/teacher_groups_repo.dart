import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/academic_stage_model.dart';
import '../models/academic_subject_model.dart';
import '../models/add_student_request_body.dart';
import '../models/add_student_response_model.dart';
import '../models/create_group_request_body.dart';
import '../models/create_group_response_model.dart';
import '../models/edit_student_request_body.dart';
import '../models/group_students_response_model.dart';
import '../models/teacher_groups_response_model.dart';
import '../models/teacher_student_details_model.dart';

class TeacherGroupsRepo {
  final ApiService _apiService;

  TeacherGroupsRepo(this._apiService);

  Future<Either<Failure, TeacherGroupsResponseModel>> getGroups() async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/groups');
      final responseModel = TeacherGroupsResponseModel.fromJson(res.data as Map<String, dynamic>);
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

  Future<Either<Failure, AcademicStageResponseModel>> getStages() async {
    try {
      final res = await _apiService.get(endpoint: '/academic/stages');
      final responseModel = AcademicStageResponseModel.fromJson(res.data as Map<String, dynamic>);
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

  Future<Either<Failure, AcademicSubjectResponseModel>> getSubjects({String? gradeLevelId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (gradeLevelId != null && gradeLevelId.isNotEmpty) {
        queryParams['gradeLevelId'] = gradeLevelId;
      }
      final res = await _apiService.get(
        endpoint: '/academic/subjects',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final responseModel = AcademicSubjectResponseModel.fromJson(res.data as Map<String, dynamic>);
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

  Future<Either<Failure, CreateGroupResponseModel>> createGroup(
    CreateGroupRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final res = await _apiService.post(
        endpoint: '/teacher/groups',
        data: formData,
      );
      final responseModel = CreateGroupResponseModel.fromJson(res.data as Map<String, dynamic>);
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء إنشاء المجموعة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, GroupStudentsResponseModel>> getGroupStudents(String groupId) async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/groups/$groupId/students');
      final responseModel = GroupStudentsResponseModel.fromJson(res.data as Map<String, dynamic>);
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب قائمة طلاب المجموعة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AddStudentResponseModel>> addStudentToGroup(
    String groupId,
    AddStudentRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final res = await _apiService.post(
        endpoint: '/teacher/groups/$groupId/students',
        data: formData,
      );
      final responseModel = AddStudentResponseModel.fromJson(res.data as Map<String, dynamic>);
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء إضافة الطالب إلى المجموعة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherStudentDetailsResponseModel>> getStudentDetails(
    String studentId,
  ) async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/students/$studentId');
      final responseModel = TeacherStudentDetailsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب بيانات الطالب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, dynamic>> updateStudentProfile(
    String studentId,
    EditStudentRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final res = await _apiService.patch(
        endpoint: '/teacher/students/$studentId/profile',
        data: formData,
      );
      return Right(res.data);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء تعديل بيانات الطالب')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
