import 'lesson_model.dart';

class LessonDetailsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherLessonModel? data;

  const LessonDetailsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory LessonDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TeacherLessonModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

