import '../../../../core/base/safe_cubit.dart';
import '../data/repos/teacher_lessons_repo.dart';
import 'teacher_video_details_state.dart';

class TeacherVideoDetailsCubit extends SafeCubit<TeacherVideoDetailsState> {
  final TeacherLessonsRepo _repo;
  final String videoId;
  final String? initialName;
  final String? initialBreadcrumb;

  TeacherVideoDetailsCubit(
    this._repo, {
    required this.videoId,
    this.initialName,
    this.initialBreadcrumb,
  }) : super(const TeacherVideoDetailsInitialState()) {
    loadVideo();
  }

  Future<void> loadVideo({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherVideoDetailsLoadingState());
    }

    final result = await _repo.getVideoDetails(videoId);

    result.fold(
      (failure) {
        emit(TeacherVideoDetailsErrorState(message: failure.message));
      },
      (response) {
        if (response.data != null) {
          emit(TeacherVideoDetailsSuccessState(video: response.data!));
        } else {
          emit(const TeacherVideoDetailsErrorState(message: 'تعذر جلب تفاصيل الفيديو'));
        }
      },
    );
  }
}

