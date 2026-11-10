import 'teacher_subject_model.dart';

class TeacherSubjectsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<TeacherSubjectModel> data;

  const TeacherSubjectsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TeacherSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TeacherSubjectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
