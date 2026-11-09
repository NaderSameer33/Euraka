abstract class TeacherEditStudentState {
  const TeacherEditStudentState();
}

class TeacherEditStudentInitial extends TeacherEditStudentState {
  const TeacherEditStudentInitial();
}

class TeacherEditStudentDataUpdated extends TeacherEditStudentState {
  final int version;
  const TeacherEditStudentDataUpdated(this.version);
}

class TeacherEditStudentSubmitting extends TeacherEditStudentState {
  const TeacherEditStudentSubmitting();
}

class TeacherEditStudentSuccess extends TeacherEditStudentState {
  final String message;
  const TeacherEditStudentSuccess(this.message);
}

class TeacherEditStudentError extends TeacherEditStudentState {
  final String message;
  const TeacherEditStudentError(this.message);
}

class TeacherDeleteStudentSubmitting extends TeacherEditStudentState {
  const TeacherDeleteStudentSubmitting();
}

class TeacherDeleteStudentSuccess extends TeacherEditStudentState {
  final String message;
  const TeacherDeleteStudentSuccess(this.message);
}

class TeacherDeleteStudentError extends TeacherEditStudentState {
  final String message;
  const TeacherDeleteStudentError(this.message);
}

