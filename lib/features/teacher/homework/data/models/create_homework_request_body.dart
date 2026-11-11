import 'homework_question_model.dart';

class CreateHomeworkRequestBody {
  final String groupId;
  final String title;
  final String unitName;
  final int durationMinutes;
  final String dueDate;
  final List<HomeworkQuestionModel> questions;
  final bool autoCloseAfterDue;

  const CreateHomeworkRequestBody({
    required this.groupId,
    required this.title,
    required this.unitName,
    this.durationMinutes = 15,
    required this.dueDate,
    required this.questions,
    this.autoCloseAfterDue = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'title': title.trim(),
      'unitName': unitName.trim().isNotEmpty ? unitName.trim() : 'الوحدة الأولى',
      'durationMinutes': durationMinutes,
      'dueDate': dueDate,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

