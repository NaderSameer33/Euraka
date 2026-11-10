import '../../../../core/base/safe_cubit.dart';
import '../data/models/subject_unit_model.dart';
import '../data/repos/teacher_subjects_repo.dart';
import 'teacher_subject_units_state.dart';

class TeacherSubjectUnitsCubit extends SafeCubit<TeacherSubjectUnitsState> {
  final TeacherSubjectsRepo _repo;
  final String subjectId;
  final String? gradeLevelId;
  final String initialSubjectName;

  List<SubjectUnitModel> _allUnits = [];
  String _currentQuery = '';

  TeacherSubjectUnitsCubit(
    this._repo, {
    required this.subjectId,
    this.gradeLevelId,
    this.initialSubjectName = 'الرياضيات',
  }) : super(const TeacherSubjectUnitsInitialState()) {
    loadUnits();
  }

  Future<void> loadUnits({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherSubjectUnitsLoadingState());
    }

    final result = await _repo.getSubjectUnits(
      subjectId: subjectId,
    );

    result.fold(
      (failure) {
        emit(TeacherSubjectUnitsErrorState(message: failure.message));
      },
      (response) {
        final data = response.data;
        _allUnits = data?.units ?? [];

        final subjectName = data?.subject?.displayName.isNotEmpty == true
            ? data!.subject!.displayName
            : initialSubjectName;

        _filterAndEmit(subjectName, data?.subject);
      },
    );
  }

  void searchUnits(String query) {
    _currentQuery = query.trim().toLowerCase();
    final currentState = state;
    if (currentState is TeacherSubjectUnitsSuccessState) {
      _filterAndEmit(currentState.subjectName, currentState.subject);
    }
  }

  void _filterAndEmit(String subjectName, dynamic subject) {
    List<SubjectUnitModel> filtered;
    if (_currentQuery.isEmpty) {
      filtered = List.from(_allUnits);
    } else {
      filtered = _allUnits.where((unit) {
        final t = unit.title.toLowerCase();
        final d = (unit.description ?? '').toLowerCase();
        return t.contains(_currentQuery) || d.contains(_currentQuery);
      }).toList();
    }

    emit(TeacherSubjectUnitsSuccessState(
      subjectName: subjectName,
      subject: subject,
      units: _allUnits,
      filteredUnits: filtered,
      searchQuery: _currentQuery,
    ));
  }
}
