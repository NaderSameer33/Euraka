import 'package:equatable/equatable.dart';
import '../data/models/teacher_subject_model.dart';

abstract class TeacherSubjectsState extends Equatable {
  const TeacherSubjectsState();

  @override
  List<Object?> get props => [];
}

class TeacherSubjectsInitialState extends TeacherSubjectsState {
  const TeacherSubjectsInitialState();
}

class TeacherSubjectsLoadingState extends TeacherSubjectsState {
  const TeacherSubjectsLoadingState();
}

class TeacherSubjectsSuccessState extends TeacherSubjectsState {
  final List<TeacherSubjectModel> subjects;
  final List<TeacherSubjectModel> filteredSubjects;
  final String searchQuery;

  const TeacherSubjectsSuccessState({
    required this.subjects,
    required this.filteredSubjects,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [subjects, filteredSubjects, searchQuery];
}

class TeacherSubjectsErrorState extends TeacherSubjectsState {
  final String message;

  const TeacherSubjectsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
