import '../../../../core/base/safe_cubit.dart';
import '../data/repos/teacher_subjects_repo.dart';
import 'teacher_unit_details_state.dart';

class TeacherUnitDetailsCubit extends SafeCubit<TeacherUnitDetailsState> {
  final TeacherSubjectsRepo _repo;
  final String unitId;
  final String? initialTitle;
  final String? initialSubjectName;

  TeacherUnitDetailsCubit(
    this._repo, {
    required this.unitId,
    this.initialTitle,
    this.initialSubjectName,
  }) : super(const TeacherUnitDetailsInitialState()) {
    loadDetails();
  }

  Future<void> loadDetails({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherUnitDetailsLoadingState());
    }

    final result = await _repo.getUnitDetails(unitId);

    result.fold(
      (failure) {
        emit(TeacherUnitDetailsErrorState(message: failure.message));
      },
      (response) {
        if (response.data != null) {
          emit(TeacherUnitDetailsSuccessState(data: response.data!));
        } else {
          emit(const TeacherUnitDetailsErrorState(
            message: 'تعذر جلب تفاصيل الوحدة',
          ));
        }
      },
    );
  }
}
