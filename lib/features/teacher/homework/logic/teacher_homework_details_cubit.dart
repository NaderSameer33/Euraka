import '../../../../core/base/safe_cubit.dart';
import '../data/repos/teacher_homework_repo.dart';
import 'teacher_homework_details_state.dart';

class TeacherHomeworkDetailsCubit extends SafeCubit<TeacherHomeworkDetailsState> {
  final TeacherHomeworkRepo _repo;
  final String homeworkId;

  TeacherHomeworkDetailsCubit(
    this._repo, {
    required this.homeworkId,
  }) : super(const TeacherHomeworkDetailsState());

  Future<void> fetchDetails() async {
    if (homeworkId.trim().isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'معرف الواجب غير صالح',
      ));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _repo.getHomeworkDetails(homeworkId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (details) {
        emit(state.copyWith(
          isLoading: false,
          homework: details,
        ));
        fetchSubmissions();
      },
    );
  }

  Future<void> fetchSubmissions() async {
    if (homeworkId.trim().isEmpty) return;
    emit(state.copyWith(isLoadingSubmissions: true));
    final result = await _repo.getHomeworkSubmissions(homeworkId);
    result.fold(
      (_) => emit(state.copyWith(isLoadingSubmissions: false)),
      (subs) => emit(state.copyWith(
        isLoadingSubmissions: false,
        submissions: subs,
      )),
    );
  }

  Future<void> deleteHomework() async {
    if (state.isDeleting || homeworkId.trim().isEmpty) return;
    emit(state.copyWith(isDeleting: true, errorMessage: null));
    final result = await _repo.deleteHomework(homeworkId);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isDeleting: false,
        isDeleted: true,
      )),
    );
  }
}
