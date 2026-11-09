import 'package:equatable/equatable.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/academic_subject_model.dart';
import '../data/models/teacher_group_model.dart';

abstract class AddGroupState extends Equatable {
  const AddGroupState();

  @override
  List<Object?> get props => [];
}

class AddGroupInitialState extends AddGroupState {
  const AddGroupInitialState();
}

class AddGroupLoadingState extends AddGroupState {
  const AddGroupLoadingState();
}

class AddGroupSuccessState extends AddGroupState {
  final TeacherGroupModel group;

  const AddGroupSuccessState(this.group);

  @override
  List<Object?> get props => [group];
}

class AddGroupErrorState extends AddGroupState {
  final String message;

  const AddGroupErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddGroupLookupsLoadedState extends AddGroupState {
  final List<AcademicStageModel> stages;
  final List<AcademicSubjectModel> subjects;
  final GradeLevelModel? selectedGrade;
  final AcademicStageModel? selectedStage;
  final AcademicSubjectModel? selectedSubject;

  const AddGroupLookupsLoadedState({
    required this.stages,
    required this.subjects,
    this.selectedGrade,
    this.selectedStage,
    this.selectedSubject,
  });

  @override
  List<Object?> get props => [
        stages,
        subjects,
        selectedGrade,
        selectedStage,
        selectedSubject,
      ];
}

