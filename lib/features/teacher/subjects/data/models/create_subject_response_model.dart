import 'teacher_subject_model.dart';

class CreateSubjectResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherSubjectModel? data;

  const CreateSubjectResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CreateSubjectResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSubjectResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TeacherSubjectModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
