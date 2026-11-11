import 'package:equatable/equatable.dart';
import '../../groups/data/models/academic_stage_model.dart';
import '../../groups/data/models/teacher_group_model.dart';
import '../../subjects/data/models/teacher_subject_model.dart';
import '../data/models/homework_question_model.dart';
import '../data/models/teacher_homework_model.dart';

class CreateHomeworkState extends Equatable {
  final int step;
  final List<AcademicStageModel> stages;
  final List<TeacherGroupModel> groups;
  final List<TeacherSubjectModel> subjects;
  final bool isInitialLoading;
  final GradeLevelModel? selectedGrade;
  final String? selectedGroupId;
  final String? selectedGroupName;
  final String? selectedSubjectId;
  final String? selectedSubjectName;
  final String teacherName;
  final String description;
  final String title;
  final String homeworkType;
  final List<HomeworkQuestionModel> questions;
  final int durationMinutes;
  final DateTime dueDate;
  final bool autoCloseAfterDue;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final TeacherHomeworkModel? createdHomework;

  CreateHomeworkState({
    this.step = 0,
    this.stages = const [],
    this.groups = const [],
    this.subjects = const [],
    this.isInitialLoading = false,
    this.selectedGrade,
    this.selectedGroupId,
    this.selectedGroupName,
    this.selectedSubjectId,
    this.selectedSubjectName,
    this.teacherName = '',
    this.description = '',
    this.title = '',
    this.homeworkType = 'MCQ',
    List<HomeworkQuestionModel>? questions,
    this.durationMinutes = 15,
    DateTime? dueDate,
    this.autoCloseAfterDue = true,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.createdHomework,
  })  : questions = questions ??
            [
              HomeworkQuestionModel(
                id: '1',
                type: 'MCQ',
                questionText: '',
                options: ['', '', '', ''],
                correctOptionIndex: 0,
                score: 2,
                order: 1,
              ),
            ],
        dueDate = dueDate ?? DateTime.now().add(const Duration(days: 3));

  int get totalScore => questions.fold(0, (sum, q) => sum + q.score);

  bool get isMcq => homeworkType == 'MCQ';

  CreateHomeworkState copyWith({
    int? step,
    List<AcademicStageModel>? stages,
    List<TeacherGroupModel>? groups,
    List<TeacherSubjectModel>? subjects,
    bool? isInitialLoading,
    GradeLevelModel? selectedGrade,
    String? selectedGroupId,
    String? selectedGroupName,
    String? selectedSubjectId,
    String? selectedSubjectName,
    String? teacherName,
    String? description,
    String? title,
    String? homeworkType,
    List<HomeworkQuestionModel>? questions,
    int? durationMinutes,
    DateTime? dueDate,
    bool? autoCloseAfterDue,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    TeacherHomeworkModel? createdHomework,
  }) {
    return CreateHomeworkState(
      step: step ?? this.step,
      stages: stages ?? this.stages,
      groups: groups ?? this.groups,
      subjects: subjects ?? this.subjects,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedGroupName: selectedGroupName ?? this.selectedGroupName,
      selectedSubjectId: selectedSubjectId ?? this.selectedSubjectId,
      selectedSubjectName: selectedSubjectName ?? this.selectedSubjectName,
      teacherName: teacherName ?? this.teacherName,
      description: description ?? this.description,
      title: title ?? this.title,
      homeworkType: homeworkType ?? this.homeworkType,
      questions: questions ?? this.questions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dueDate: dueDate ?? this.dueDate,
      autoCloseAfterDue: autoCloseAfterDue ?? this.autoCloseAfterDue,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      createdHomework: createdHomework ?? this.createdHomework,
    );
  }

  @override
  List<Object?> get props => [
        step,
        stages,
        groups,
        subjects,
        isInitialLoading,
        selectedGrade,
        selectedGroupId,
        selectedGroupName,
        selectedSubjectId,
        selectedSubjectName,
        teacherName,
        description,
        title,
        homeworkType,
        questions,
        durationMinutes,
        dueDate,
        autoCloseAfterDue,
        isLoading,
        isSuccess,
        errorMessage,
        createdHomework,
      ];
}
