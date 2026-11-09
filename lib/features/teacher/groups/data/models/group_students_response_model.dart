import 'group_student_model.dart';

class GroupStudentsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final GroupStudentsData? data;

  const GroupStudentsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory GroupStudentsResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupStudentsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? GroupStudentsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class GroupStudentsData {
  final String groupName;
  final String groupCode;
  final List<GroupStudentModel> students;
  final int totalCount;

  const GroupStudentsData({
    required this.groupName,
    required this.groupCode,
    required this.students,
    this.totalCount = 0,
  });

  factory GroupStudentsData.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>?;
    final total = pagination?['totalCount'] as int? ?? 0;
    final list = (json['students'] as List<dynamic>?)
            ?.map((e) => GroupStudentModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return GroupStudentsData(
      groupName: json['groupName'] as String? ?? '',
      groupCode: json['groupCode'] as String? ?? '',
      students: list,
      totalCount: total,
    );
  }
}

