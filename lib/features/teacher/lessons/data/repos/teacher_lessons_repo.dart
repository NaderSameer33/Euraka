import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../../../groups/data/models/teacher_groups_response_model.dart';
import '../../../subjects/data/models/subject_units_response_model.dart';
import '../../../subjects/data/models/teacher_subjects_response_model.dart';
import '../models/create_lesson_request_body.dart';
import '../models/create_video_request_body.dart';
import '../models/lesson_details_response_model.dart';
import '../models/lesson_model.dart';
import '../models/lesson_video_details_response_model.dart';
import '../models/unit_lessons_response_model.dart';

class TeacherLessonsRepo {
  final ApiService _apiService;

  TeacherLessonsRepo(this._apiService);

  Future<Either<Failure, UnitLessonsResponseModel>> getUnitLessons(String unitId) async {
    try {
      final res = await _apiService.get(
        endpoint: '/academic/units/$unitId/lessons',
      );
      final responseModel = UnitLessonsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب دروس الوحدة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonDetailsResponseModel>> getLessonDetails(String lessonId) async {
    try {
      final res = await _apiService.get(
        endpoint: '/academic/lessons/$lessonId',
      );
      final responseModel = LessonDetailsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب تفاصيل الدرس')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherLessonModel>> createLesson(CreateLessonRequestBody request) async {
    try {
      final formData = await request.toFormData();
      final res = await _apiService.post(
        endpoint: '/teacher/lessons',
        data: formData,
      );
      final data = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      if (data != null) {
        return Right(TeacherLessonModel.fromJson(data));
      }
      return const Left(ServerFailure('تم إنشاء الدرس بنجاح'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء إنشاء الدرس')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonVideoDetailsResponseModel>> getVideoDetails(String videoId) async {
    try {
      final res = await _apiService.get(
        endpoint: '/academic/videos/$videoId',
      );
      final responseModel = LessonVideoDetailsResponseModel.fromJson(
        res.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب تفاصيل الفيديو')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonVideoModel>> createVideo(CreateVideoRequestBody request) async {
    try {
      final formData = await request.toFormData();
      final res = await _apiService.post(
        endpoint: '/teacher/videos',
        data: formData,
      );
      final data = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      if (data != null) {
        return Right(LessonVideoModel.fromJson(data));
      }
      return const Left(ServerFailure('تم رفع الفيديو بنجاح'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء رفع الفيديو')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonMaterialModel>> createMaterial({
    required String lessonId,
    required String title,
    required String filePath,
    String? description,
    String? groupId,
  }) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'title': title,
        if (description != null && description.trim().isNotEmpty) 'description': description.trim(),
        if (groupId != null && groupId.trim().isNotEmpty) 'groupId': groupId.trim(),
        'document': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final res = await _apiService.post(
        endpoint: '/teacher/lessons/$lessonId/materials',
        data: formData,
      );
      final data = res.data is Map ? (res.data['data'] as Map<String, dynamic>?) : null;
      if (data != null) {
        return Right(LessonMaterialModel.fromJson(data));
      }
      return const Left(ServerFailure('تم رفع المستند بنجاح'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء رفع المستند')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherSubjectsResponseModel>> getSubjects() async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/subjects');
      return Right(TeacherSubjectsResponseModel.fromJson(res.data as Map<String, dynamic>));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب المواد')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, SubjectUnitsResponseModel>> getSubjectUnits(String subjectId) async {
    try {
      final res = await _apiService.get(endpoint: '/academic/subjects/$subjectId/units');
      return Right(SubjectUnitsResponseModel.fromJson(res.data as Map<String, dynamic>));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ أثناء جلب وحدات المادة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherGroupsResponseModel>> getGroups() async {
    try {
      final res = await _apiService.get(endpoint: '/teacher/groups');
      return Right(TeacherGroupsResponseModel.fromJson(res.data as Map<String, dynamic>));
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
