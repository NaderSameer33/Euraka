import 'lesson_model.dart';

class UnitLessonsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final UnitLessonsData? data;

  const UnitLessonsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UnitLessonsResponseModel.fromJson(Map<String, dynamic> json) {
    return UnitLessonsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UnitLessonsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UnitLessonsData {
  final String unitId;
  final List<TeacherLessonModel> lessons;

  const UnitLessonsData({
    required this.unitId,
    required this.lessons,
  });

  factory UnitLessonsData.fromJson(Map<String, dynamic> json) {
    final list = (json['lessons'] as List<dynamic>?)
            ?.map((e) => TeacherLessonModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return UnitLessonsData(
      unitId: json['unitId'] as String? ?? '',
      lessons: list,
    );
  }
}

