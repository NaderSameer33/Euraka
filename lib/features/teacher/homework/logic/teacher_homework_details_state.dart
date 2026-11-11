import 'package:equatable/equatable.dart';
import '../data/models/teacher_homework_model.dart';

class TeacherHomeworkDetailsState extends Equatable {
  final bool isLoading;
  final bool isDeleting;
  final TeacherHomeworkModel? homework;
  final List<dynamic> submissions;
  final bool isLoadingSubmissions;
  final String? errorMessage;
  final bool isDeleted;

  const TeacherHomeworkDetailsState({
    this.isLoading = false,
    this.isDeleting = false,
    this.homework,
    this.submissions = const [],
    this.isLoadingSubmissions = false,
    this.errorMessage,
    this.isDeleted = false,
  });

  TeacherHomeworkDetailsState copyWith({
    bool? isLoading,
    bool? isDeleting,
    TeacherHomeworkModel? homework,
    List<dynamic>? submissions,
    bool? isLoadingSubmissions,
    String? errorMessage,
    bool? isDeleted,
  }) {
    return TeacherHomeworkDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      homework: homework ?? this.homework,
      submissions: submissions ?? this.submissions,
      isLoadingSubmissions: isLoadingSubmissions ?? this.isLoadingSubmissions,
      errorMessage: errorMessage,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isDeleting,
        homework,
        submissions,
        isLoadingSubmissions,
        errorMessage,
        isDeleted,
      ];
}
