import 'teacher_group_model.dart';

class TeacherGroupsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherGroupsData? data;

  const TeacherGroupsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory TeacherGroupsResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherGroupsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TeacherGroupsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TeacherGroupsData {
  final List<TeacherGroupModel> groups;
  final int totalCount;

  const TeacherGroupsData({
    required this.groups,
    this.totalCount = 0,
  });

  factory TeacherGroupsData.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>?;
    final total = pagination?['totalCount'] as int? ?? 0;
    final groupsList = (json['groups'] as List<dynamic>?)
            ?.map((e) => TeacherGroupModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return TeacherGroupsData(
      groups: groupsList,
      totalCount: total,
    );
  }
}

