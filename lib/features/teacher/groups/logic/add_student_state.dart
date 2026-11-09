import 'dart:io';
import 'package:equatable/equatable.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/add_student_response_model.dart';

abstract class AddStudentState extends Equatable {
  const AddStudentState();

  @override
  List<Object?> get props => [];
}

class AddStudentInitialState extends AddStudentState {
  const AddStudentInitialState();
}

class AddStudentLoadingState extends AddStudentState {
  const AddStudentLoadingState();
}

class AddStudentSuccessState extends AddStudentState {
  final AddStudentData data;

  const AddStudentSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AddStudentErrorState extends AddStudentState {
  final String message;

  const AddStudentErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddStudentLookupsLoadedState extends AddStudentState {
  final List<AcademicStageModel> stages;
  final GradeLevelModel? selectedGrade;
  final AcademicStageModel? selectedStage;
  final File? photoFile;
  final int version;

  const AddStudentLookupsLoadedState({
    required this.stages,
    this.selectedGrade,
    this.selectedStage,
    this.photoFile,
    this.version = 0,
  });

  @override
  List<Object?> get props => [
        stages,
        selectedGrade,
        selectedStage,
        photoFile?.path,
        version,
      ];
}
