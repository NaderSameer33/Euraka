import 'homework_question_model.dart';

class TeacherHomeworkModel {
  final String id;
  final String groupId;
  final String? groupName;
  final String? subjectName;
  final String title;
  final String unitName;
  final int durationMinutes;
  final int totalScore;
  final String dueDate;
  final int questionsCount;
  final int totalEnrolled;
  final int submissionsCount;
  final int submissionRatePercentage;
  final String? createdAt;
  final List<HomeworkQuestionModel> questions;

  const TeacherHomeworkModel({
    required this.id,
    required this.groupId,
    this.groupName,
    this.subjectName,
    required this.title,
    this.unitName = 'الوحدة الأولى',
    this.durationMinutes = 15,
    this.totalScore = 0,
    required this.dueDate,
    this.questionsCount = 0,
    this.totalEnrolled = 0,
    this.submissionsCount = 0,
    this.submissionRatePercentage = 0,
    this.createdAt,
    this.questions = const [],
  });

  int get remainingDays {
    try {
      final due = DateTime.parse(dueDate);
      final diff = due.difference(DateTime.now()).inDays;
      return diff < 0 ? 0 : diff;
    } catch (_) {
      return 0;
    }
  }

  int get pendingCount {
    final pending = totalEnrolled - submissionsCount;
    return pending < 0 ? 0 : pending;
  }

  factory TeacherHomeworkModel.fromJson(Map<String, dynamic> json) {
    final groupObj = json['group'] as Map<String, dynamic>?;
    final subObj = groupObj?['subject'] as Map<String, dynamic>?;

    final qList = (json['questions'] as List<dynamic>?)
            ?.map((e) => HomeworkQuestionModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final groupCount = groupObj?['_count'] as Map<String, dynamic>?;
    final rootCount = json['_count'] as Map<String, dynamic>?;

    final enrolled = json['totalEnrolled'] as int? ??
        (groupCount?['enrollments'] as int?) ??
        0;

    final submissions = json['submissionsCount'] as int? ??
        (rootCount?['submissions'] as int?) ??
        0;

    return TeacherHomeworkModel(
      id: json['id'] as String? ?? '',
      groupId: json['groupId'] as String? ?? '',
      groupName: json['groupName'] as String? ?? (groupObj?['name'] as String?),
      subjectName: json['subjectName'] as String? ?? (subObj?['nameAr'] as String?),
      title: json['title'] as String? ?? '',
      unitName: json['unitName'] as String? ?? 'الوحدة الأولى',
      durationMinutes: json['durationMinutes'] as int? ?? 15,
      totalScore: json['totalScore'] as int? ?? 0,
      dueDate: json['dueDate'] as String? ?? '',
      questionsCount: json['questionsCount'] as int? ?? qList.length,
      totalEnrolled: enrolled,
      submissionsCount: submissions,
      submissionRatePercentage: json['submissionRatePercentage'] as int? ?? 0,
      createdAt: json['createdAt'] as String?,
      questions: qList,
    );
  }
}
