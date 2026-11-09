import 'teacher_group_model.dart';

class CreateGroupResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherGroupModel? data;

  const CreateGroupResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CreateGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateGroupResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TeacherGroupModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

