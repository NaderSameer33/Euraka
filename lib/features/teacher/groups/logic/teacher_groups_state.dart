import 'package:equatable/equatable.dart';
import '../data/models/teacher_group_model.dart';

abstract class TeacherGroupsState extends Equatable {
  const TeacherGroupsState();

  @override
  List<Object?> get props => [];
}

class TeacherGroupsInitialState extends TeacherGroupsState {
  const TeacherGroupsInitialState();
}

class TeacherGroupsLoadingState extends TeacherGroupsState {
  const TeacherGroupsLoadingState();
}

class TeacherGroupsSuccessState extends TeacherGroupsState {
  final List<TeacherGroupModel> groups;
  final List<TeacherGroupModel> filteredGroups;
  final String searchQuery;

  const TeacherGroupsSuccessState({
    required this.groups,
    required this.filteredGroups,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [groups, filteredGroups, searchQuery];
}

class TeacherGroupsErrorState extends TeacherGroupsState {
  final String message;

  const TeacherGroupsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

