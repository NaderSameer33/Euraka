import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../data/models/teacher_group_model.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'teacher_groups_state.dart';

class TeacherGroupsCubit extends SafeCubit<TeacherGroupsState> {
  final TeacherGroupsRepo _repo;
  final SharedPrefService _sharedPref;

  TeacherGroupsCubit(
    this._repo,
    this._sharedPref,
  ) : super(const TeacherGroupsInitialState()) {
    loadGroups();
  }

  String get teacherName {
    final fullName = _sharedPref.getString(AppConstants.userFullNameKey);
    if (fullName != null && fullName.trim().isNotEmpty) {
      final trimmed = fullName.trim();
      if (trimmed.startsWith('أ/') || trimmed.startsWith('أ /')) {
        return trimmed;
      }
      return 'أ / $trimmed';
    }
    return 'أ / محمد سامي';
  }

  Future<void> loadGroups({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherGroupsLoadingState());
    }

    final result = await _repo.getGroups();

    result.fold(
      (failure) {
        emit(TeacherGroupsErrorState(message: failure.message));
      },
      (response) {
        final groups = response.data?.groups ?? [];
        emit(TeacherGroupsSuccessState(
          groups: groups,
          filteredGroups: groups,
        ));
      },
    );
  }

  void searchGroups(String query) {
    if (state is! TeacherGroupsSuccessState) return;
    final currentState = state as TeacherGroupsSuccessState;
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      emit(TeacherGroupsSuccessState(
        groups: currentState.groups,
        filteredGroups: currentState.groups,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.groups.where((group) {
      final matchName = group.name.toLowerCase().contains(trimmed);
      final matchSubject = group.subjectName.toLowerCase().contains(trimmed);
      final matchGrade = group.gradeLevelName.toLowerCase().contains(trimmed);
      return matchName || matchSubject || matchGrade;
    }).toList();

    emit(TeacherGroupsSuccessState(
      groups: currentState.groups,
      filteredGroups: filtered,
      searchQuery: query,
    ));
  }

  static List<TeacherGroupModel> dummyGroups() {
    return const [
      TeacherGroupModel(
        id: '1',
        name: 'مجموعه أ',
        gradeLevelName: 'الصف الثالث الثانوي',
        subjectName: 'فيزياء',
        studentCount: 42,
      ),
      TeacherGroupModel(
        id: '2',
        name: 'مجموعه ب',
        gradeLevelName: 'الصف الثالث الثانوي',
        subjectName: 'فيزياء',
        studentCount: 42,
      ),
      TeacherGroupModel(
        id: '3',
        name: 'مجموعه أ',
        gradeLevelName: 'الصف الثالث الثانوي',
        subjectName: 'الكيمياء',
        studentCount: 42,
      ),
      TeacherGroupModel(
        id: '4',
        name: 'مجموعه ج',
        gradeLevelName: 'الصف الثالث الثانوي',
        subjectName: 'فيزياء',
        studentCount: 42,
      ),
    ];
  }
}

