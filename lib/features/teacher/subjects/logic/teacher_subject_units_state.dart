import '../data/models/subject_unit_model.dart';
import '../data/models/teacher_subject_model.dart';

abstract class TeacherSubjectUnitsState {
  const TeacherSubjectUnitsState();
}

class TeacherSubjectUnitsInitialState extends TeacherSubjectUnitsState {
  const TeacherSubjectUnitsInitialState();
}

class TeacherSubjectUnitsLoadingState extends TeacherSubjectUnitsState {
  const TeacherSubjectUnitsLoadingState();
}

class TeacherSubjectUnitsSuccessState extends TeacherSubjectUnitsState {
  final String subjectName;
  final TeacherSubjectModel? subject;
  final List<SubjectUnitModel> units;
  final List<SubjectUnitModel> filteredUnits;
  final String searchQuery;

  const TeacherSubjectUnitsSuccessState({
    required this.subjectName,
    this.subject,
    required this.units,
    required this.filteredUnits,
    this.searchQuery = '',
  });
}

class TeacherSubjectUnitsErrorState extends TeacherSubjectUnitsState {
  final String message;
  const TeacherSubjectUnitsErrorState({required this.message});
}

