import 'package:equatable/equatable.dart';
import '../data/models/teacher_homework_model.dart';

class TeacherHomeworkListState extends Equatable {
  final bool isLoading;
  final List<TeacherHomeworkModel> homeworks;
  final String? errorMessage;
  final String? deleteSuccessMessage;

  const TeacherHomeworkListState({
    this.isLoading = false,
    this.homeworks = const [],
    this.errorMessage,
    this.deleteSuccessMessage,
  });

  TeacherHomeworkListState copyWith({
    bool? isLoading,
    List<TeacherHomeworkModel>? homeworks,
    String? errorMessage,
    String? deleteSuccessMessage,
  }) {
    return TeacherHomeworkListState(
      isLoading: isLoading ?? this.isLoading,
      homeworks: homeworks ?? this.homeworks,
      errorMessage: errorMessage,
      deleteSuccessMessage: deleteSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        homeworks,
        errorMessage,
        deleteSuccessMessage,
      ];
}
