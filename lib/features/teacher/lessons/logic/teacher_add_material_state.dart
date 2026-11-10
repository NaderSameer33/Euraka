import 'package:equatable/equatable.dart';
import '../../groups/data/models/teacher_group_model.dart';
import '../data/models/lesson_model.dart';

abstract class TeacherAddMaterialState extends Equatable {
  const TeacherAddMaterialState();

  @override
  List<Object?> get props => [];
}

class TeacherAddMaterialInitialState extends TeacherAddMaterialState {
  const TeacherAddMaterialInitialState();
}

class TeacherAddMaterialGroupsLoadingState extends TeacherAddMaterialState {
  const TeacherAddMaterialGroupsLoadingState();
}

class TeacherAddMaterialGroupsLoadedState extends TeacherAddMaterialState {
  final List<TeacherGroupModel> groups;

  const TeacherAddMaterialGroupsLoadedState(this.groups);

  @override
  List<Object?> get props => [groups];
}

class TeacherAddMaterialFileSelectedState extends TeacherAddMaterialState {
  final String filePath;
  final String fileName;
  final int fileSizeBytes;

  const TeacherAddMaterialFileSelectedState({
    required this.filePath,
    required this.fileName,
    required this.fileSizeBytes,
  });

  @override
  List<Object?> get props => [filePath, fileName, fileSizeBytes];
}

class TeacherAddMaterialSubmittingState extends TeacherAddMaterialState {
  const TeacherAddMaterialSubmittingState();
}

class TeacherAddMaterialSuccessState extends TeacherAddMaterialState {
  final LessonMaterialModel material;

  const TeacherAddMaterialSuccessState(this.material);

  @override
  List<Object?> get props => [material];
}

class TeacherAddMaterialErrorState extends TeacherAddMaterialState {
  final String message;

  const TeacherAddMaterialErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

