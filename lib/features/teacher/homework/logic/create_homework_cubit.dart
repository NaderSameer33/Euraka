import '../../../../core/base/safe_cubit.dart';
import '../../groups/data/models/academic_stage_model.dart';
import '../../groups/data/repos/teacher_groups_repo.dart';
import '../../subjects/data/repos/teacher_subjects_repo.dart';
import '../data/models/create_homework_request_body.dart';
import '../data/models/homework_question_model.dart';
import '../data/repos/teacher_homework_repo.dart';
import 'create_homework_state.dart';

class CreateHomeworkCubit extends SafeCubit<CreateHomeworkState> {
  final TeacherHomeworkRepo _homeworkRepo;
  final TeacherGroupsRepo _groupsRepo;
  final TeacherSubjectsRepo _subjectsRepo;

  CreateHomeworkCubit(
    this._homeworkRepo,
    this._groupsRepo,
    this._subjectsRepo,
  ) : super(CreateHomeworkState());

  Future<void> fetchInitialData() async {
    emit(state.copyWith(isInitialLoading: true));
    try {
      final stagesRes = await _groupsRepo.getStages();
      final groupsRes = await _groupsRepo.getGroups();
      final subjectsRes = await _subjectsRepo.getSubjects();

      final stages = stagesRes.fold((_) => state.stages, (data) => data.data);
      final groups = groupsRes.fold((_) => state.groups, (data) => data.data?.groups ?? []);
      final subjects = subjectsRes.fold((_) => state.subjects, (data) => data.data);

      String? initialGroupId = state.selectedGroupId;
      String? initialGroupName = state.selectedGroupName;
      if (initialGroupId == null && groups.isNotEmpty) {
        initialGroupId = groups.first.id;
        initialGroupName = groups.first.name;
      }

      String? initialSubjectId = state.selectedSubjectId;
      String? initialSubjectName = state.selectedSubjectName;
      if (initialSubjectId == null && subjects.isNotEmpty) {
        initialSubjectId = subjects.first.id;
        initialSubjectName = subjects.first.nameAr;
      }

      emit(state.copyWith(
        isInitialLoading: false,
        stages: stages,
        groups: groups,
        subjects: subjects,
        selectedGroupId: initialGroupId,
        selectedGroupName: initialGroupName,
        selectedSubjectId: initialSubjectId,
        selectedSubjectName: initialSubjectName,
      ));
    } catch (_) {
      emit(state.copyWith(isInitialLoading: false));
    }
  }

  void setGrade(GradeLevelModel grade) {
    emit(state.copyWith(selectedGrade: grade));
  }

  void setGroup(String id, String name) {
    emit(state.copyWith(selectedGroupId: id, selectedGroupName: name));
  }

  void setSubject(String id, String name) {
    emit(state.copyWith(selectedSubjectId: id, selectedSubjectName: name));
  }

  void setTeacherName(String name) {
    emit(state.copyWith(teacherName: name));
  }

  void setDescription(String desc) {
    emit(state.copyWith(description: desc));
  }

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void setHomeworkType(String type) {
    final updatedQuestions = state.questions.map((q) {
      return HomeworkQuestionModel(
        id: q.id,
        type: type,
        questionText: q.questionText,
        options: type == 'MCQ' ? (q.options.isEmpty ? ['', '', '', ''] : q.options) : [],
        correctOptionIndex: q.correctOptionIndex,
        modelAnswer: type == 'ESSAY' ? (q.modelAnswer ?? '') : null,
        score: q.score,
        order: q.order,
      );
    }).toList();

    emit(state.copyWith(
      homeworkType: type,
      questions: updatedQuestions,
    ));
  }

  void addQuestion() {
    final newOrder = state.questions.length + 1;
    final newQuestion = HomeworkQuestionModel(
      id: UniqueKey().toString(),
      type: state.homeworkType,
      questionText: '',
      options: state.isMcq ? ['', '', '', ''] : [],
      correctOptionIndex: 0,
      modelAnswer: state.isMcq ? null : '',
      score: state.isMcq ? 2 : 5,
      order: newOrder,
    );
    emit(state.copyWith(
      questions: [...state.questions, newQuestion],
    ));
  }

  void removeQuestion(int index) {
    if (state.questions.length <= 1) return;
    final updated = List<HomeworkQuestionModel>.from(state.questions)..removeAt(index);
    for (int i = 0; i < updated.length; i++) {
      updated[i].order = i + 1;
    }
    emit(state.copyWith(questions: updated));
  }

  void updateQuestionText(int index, String text) {
    if (index >= state.questions.length) return;
    state.questions[index].questionText = text;
    emit(state.copyWith(questions: List.from(state.questions)));
  }

  void updateOptionText(int qIndex, int optionIndex, String text) {
    if (qIndex >= state.questions.length) return;
    final q = state.questions[qIndex];
    if (optionIndex < q.options.length) {
      q.options[optionIndex] = text;
      emit(state.copyWith(questions: List.from(state.questions)));
    }
  }

  void setCorrectOption(int qIndex, int optionIndex) {
    if (qIndex >= state.questions.length) return;
    state.questions[qIndex].correctOptionIndex = optionIndex;
    emit(state.copyWith(questions: List.from(state.questions)));
  }

  void updateModelAnswer(int qIndex, String answer) {
    if (qIndex >= state.questions.length) return;
    state.questions[qIndex].modelAnswer = answer;
    emit(state.copyWith(questions: List.from(state.questions)));
  }

  void updateScore(int qIndex, int score) {
    if (qIndex >= state.questions.length) return;
    state.questions[qIndex].score = score;
    emit(state.copyWith(questions: List.from(state.questions)));
  }

  void setDurationMinutes(int duration) {
    emit(state.copyWith(durationMinutes: duration));
  }

  void setDueDate(DateTime date) {
    emit(state.copyWith(dueDate: date));
  }

  void setAutoCloseAfterDue(bool autoClose) {
    emit(state.copyWith(autoCloseAfterDue: autoClose));
  }

  bool canProceedFromStep(int currentStep, {Function(String)? onError}) {
    if (currentStep == 0) {
      if (state.selectedGroupId == null || state.selectedGroupId!.isEmpty) {
        onError?.call('يرجى اختيار المجموعة');
        return false;
      }
      return true;
    } else if (currentStep == 1) {
      if (state.title.trim().isEmpty) {
        onError?.call('يرجى إدخال اسم الواجب');
        return false;
      }
      return true;
    } else if (currentStep == 2) {
      for (int i = 0; i < state.questions.length; i++) {
        final q = state.questions[i];
        if (q.questionText.trim().isEmpty) {
          onError?.call('يرجى إدخال نص السؤال ${i + 1}');
          return false;
        }
        if (q.isMcq) {
          final filled = q.options.where((o) => o.trim().isNotEmpty).length;
          if (filled < 2) {
            onError?.call('يرجى إدخال خيارين على الأقل للسؤال ${i + 1}');
            return false;
          }
        } else {
          if ((q.modelAnswer ?? '').trim().isEmpty) {
            onError?.call('يرجى إدخال الإجابة النموذجية للسؤال ${i + 1}');
            return false;
          }
        }
      }
      return true;
    }
    return true;
  }

  void nextStep({Function(String)? onError}) {
    if (canProceedFromStep(state.step, onError: onError)) {
      if (state.step < 4) {
        emit(state.copyWith(step: state.step + 1));
      }
    }
  }

  void previousStep() {
    if (state.step > 0) {
      emit(state.copyWith(step: state.step - 1));
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      emit(state.copyWith(step: step));
    }
  }

  Future<void> publishHomework() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final requestBody = CreateHomeworkRequestBody(
      groupId: state.selectedGroupId ?? '',
      title: state.title.trim().isNotEmpty ? state.title.trim() : 'واجب جديد',
      unitName: 'الوحدة الأولى',
      durationMinutes: state.durationMinutes,
      dueDate: state.dueDate.toUtc().toIso8601String(),
      questions: state.questions,
      autoCloseAfterDue: state.autoCloseAfterDue,
    );

    final result = await _homeworkRepo.createHomework(requestBody);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (homework) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          createdHomework: homework,
        ));
      },
    );
  }
}

class UniqueKey {
  static int _c = 0;
  @override
  String toString() => '${DateTime.now().millisecondsSinceEpoch}_${_c++}';
}
