import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../data/models/teacher_subject_model.dart';
import '../data/repos/teacher_subjects_repo.dart';
import 'teacher_subjects_state.dart';

class TeacherSubjectsCubit extends SafeCubit<TeacherSubjectsState> {
  final TeacherSubjectsRepo _repo;
  final SharedPrefService _sharedPref;

  TeacherSubjectsCubit(
    this._repo,
    this._sharedPref,
  ) : super(const TeacherSubjectsInitialState()) {
    loadSubjects();
  }

  String get teacherName {
    final fullName = _sharedPref.getString(AppConstants.userFullNameKey);
    if (fullName != null && fullName.trim().isNotEmpty) {
      final trimmed = fullName.trim();
      if (trimmed.startsWith('أ/') || trimmed.startsWith('أ /')) {
        return trimmed;
      }
      return 'أ/ $trimmed';
    }
    return 'أ/ محمد سامي';
  }

  Future<void> loadSubjects({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherSubjectsLoadingState());
    }

    final result = await _repo.getSubjects();

    result.fold(
      (failure) {
        emit(TeacherSubjectsErrorState(message: failure.message));
      },
      (response) {
        emit(TeacherSubjectsSuccessState(
          subjects: response.data,
          filteredSubjects: response.data,
        ));
      },
    );
  }

  void searchSubjects(String query) {
    if (state is! TeacherSubjectsSuccessState) return;
    final currentState = state as TeacherSubjectsSuccessState;
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      emit(TeacherSubjectsSuccessState(
        subjects: currentState.subjects,
        filteredSubjects: currentState.subjects,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.subjects.where((subject) {
      final matchAr = subject.nameAr.toLowerCase().contains(trimmed);
      final matchEn = (subject.nameEn ?? '').toLowerCase().contains(trimmed);
      final matchGrade = (subject.gradeLevel?.nameAr ?? '').toLowerCase().contains(trimmed);
      final matchDesc = (subject.description ?? '').toLowerCase().contains(trimmed);
      return matchAr || matchEn || matchGrade || matchDesc;
    }).toList();

    emit(TeacherSubjectsSuccessState(
      subjects: currentState.subjects,
      filteredSubjects: filtered,
      searchQuery: query,
    ));
  }

  static List<TeacherSubjectModel> dummySubjects() {
    return List.generate(
      6,
      (index) => TeacherSubjectModel(
        id: 'dummy_$index',
        nameAr: index == 0
            ? 'الفيزياء'
            : index == 1
                ? 'الكيمياء'
                : index == 2
                    ? 'الأحياء'
                    : 'الرياضيات',
        nameEn: 'Subject',
        gradeLevel: const TeacherSubjectGradeLevelModel(
          id: 'dummy_grade',
          nameAr: 'الصف الثالث الثانوي',
        ),
        unitsCount: 5,
        groupsCount: 3,
      ),
    );
  }
}
