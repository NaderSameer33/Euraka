import 'package:equatable/equatable.dart';
import '../data/models/group_student_model.dart';

abstract class GroupStudentsState extends Equatable {
  const GroupStudentsState();

  @override
  List<Object?> get props => [];
}

class GroupStudentsInitialState extends GroupStudentsState {
  const GroupStudentsInitialState();
}

class GroupStudentsLoadingState extends GroupStudentsState {
  const GroupStudentsLoadingState();
}

class GroupStudentsSuccessState extends GroupStudentsState {
  final String groupName;
  final String groupCode;
  final List<GroupStudentModel> students;
  final List<GroupStudentModel> filteredStudents;
  final String searchQuery;

  const GroupStudentsSuccessState({
    required this.groupName,
    required this.groupCode,
    required this.students,
    required this.filteredStudents,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        groupName,
        groupCode,
        students,
        filteredStudents,
        searchQuery,
      ];
}

class GroupStudentsErrorState extends GroupStudentsState {
  final String message;

  const GroupStudentsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

