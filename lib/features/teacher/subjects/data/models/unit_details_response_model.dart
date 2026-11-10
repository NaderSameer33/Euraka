import '../../../../../core/constants/app_constants.dart';
import 'subject_unit_model.dart';
import 'teacher_subject_model.dart';

class UnitDetailsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final UnitDetailsData? data;

  const UnitDetailsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UnitDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UnitDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UnitDetailsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UnitDetailsData {
  final String id;
  final String subjectId;
  final String gradeLevelId;
  final String title;
  final int order;
  final int unitNumber;
  final String? photoUrl;
  final String? description;
  final TeacherSubjectModel? subject;
  final String subjectName;
  final String gradeLevelName;
  final String teacherName;
  final List<UnitLessonModel> lessons;

  const UnitDetailsData({
    required this.id,
    required this.subjectId,
    required this.gradeLevelId,
    required this.title,
    this.order = 1,
    this.unitNumber = 1,
    this.photoUrl,
    this.description,
    this.subject,
    this.subjectName = 'الرياضيات',
    this.gradeLevelName = '',
    this.teacherName = '',
    this.lessons = const [],
  });

  factory UnitDetailsData.fromJson(Map<String, dynamic> json) {
    final sub = json['subject'] != null && json['subject'] is Map<String, dynamic>
        ? TeacherSubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
        : null;
    final grade = json['gradeLevel'] as Map<String, dynamic>?;
    final creator = json['createdBy'] as Map<String, dynamic>?;

    final rawLessons = (json['lessons'] as List<dynamic>?)
            ?.map((e) => UnitLessonModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    return UnitDetailsData(
      id: json['id'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      gradeLevelId: json['gradeLevelId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      order: json['order'] as int? ?? 1,
      unitNumber: json['unitNumber'] as int? ?? (json['order'] as int? ?? 1),
      photoUrl: AppConstants.formatImageUrl(json['photoUrl'] as String?),
      description: json['description'] as String?,
      subject: sub,
      subjectName: sub?.displayName ?? (grade?['nameAr'] as String? ?? 'الرياضيات'),
      gradeLevelName: grade?['nameAr'] as String? ?? '',
      teacherName: creator?['fullName'] as String? ?? '',
      lessons: rawLessons,
    );
  }

  static UnitDetailsData dummy({String title = 'الجبر', String subjectName = 'الرياضيات'}) {
    return UnitDetailsData(
      id: 'dummy',
      subjectId: 'dummy_sub',
      gradeLevelId: 'dummy_grade',
      title: title,
      unitNumber: 1,
      subjectName: subjectName,
      description: 'مفاهيم الجبر الأساسية',
      lessons: UnitLessonModel.dummyLessons(),
    );
  }
}

