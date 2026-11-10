import '../../../../core/base/safe_cubit.dart';
import '../data/repos/teacher_lessons_repo.dart';
import 'teacher_lesson_details_state.dart';

class TeacherLessonDetailsCubit extends SafeCubit<TeacherLessonDetailsState> {
  final TeacherLessonsRepo _repo;
  final String lessonId;

  TeacherLessonDetailsCubit(
    this._repo, {
    required this.lessonId,
  }) : super(const TeacherLessonDetailsInitialState()) {
    loadLesson();
  }

  Future<void> loadLesson({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherLessonDetailsLoadingState());
    }

    final result = await _repo.getLessonDetails(lessonId);

    result.fold(
      (failure) {
        emit(TeacherLessonDetailsErrorState(message: failure.message));
      },
      (response) {
        if (response.data != null) {
          emit(TeacherLessonDetailsSuccessState(lesson: response.data!));
        } else {
          emit(const TeacherLessonDetailsErrorState(message: 'تعذر جلب تفاصيل الدرس'));
        }
      },
    );
  }
}

