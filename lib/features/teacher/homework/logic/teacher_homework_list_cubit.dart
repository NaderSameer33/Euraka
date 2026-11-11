import '../../../../core/base/safe_cubit.dart';
import '../data/repos/teacher_homework_repo.dart';
import 'teacher_homework_list_state.dart';

class TeacherHomeworkListCubit extends SafeCubit<TeacherHomeworkListState> {
  final TeacherHomeworkRepo _repo;

  TeacherHomeworkListCubit(this._repo) : super(const TeacherHomeworkListState());

  Future<void> fetchHomeworks({String? groupId}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _repo.getHomeworks(groupId: groupId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (list) => emit(state.copyWith(
        isLoading: false,
        homeworks: list,
      )),
    );
  }

  Future<void> deleteHomework(String id) async {
    final result = await _repo.deleteHomework(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (msg) {
        final updated = state.homeworks.where((h) => h.id != id).toList();
        emit(state.copyWith(
          homeworks: updated,
          deleteSuccessMessage: msg,
        ));
      },
    );
  }
}

