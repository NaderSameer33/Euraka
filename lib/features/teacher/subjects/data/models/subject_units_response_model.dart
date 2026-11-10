import 'subject_unit_model.dart';
import 'teacher_subject_model.dart';

class SubjectUnitsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final SubjectUnitsData? data;

  const SubjectUnitsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory SubjectUnitsResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectUnitsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SubjectUnitsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SubjectUnitsData {
  final TeacherSubjectModel? subject;
  final List<SubjectUnitModel> units;

  const SubjectUnitsData({
    this.subject,
    this.units = const [],
  });

  factory SubjectUnitsData.fromJson(Map<String, dynamic> json) {
    return SubjectUnitsData(
      subject: json['subject'] != null && json['subject'] is Map<String, dynamic>
          ? TeacherSubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
          : null,
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => SubjectUnitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

