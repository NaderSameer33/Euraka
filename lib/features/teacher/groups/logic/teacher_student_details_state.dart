import '../data/models/teacher_student_details_model.dart';

abstract class TeacherStudentDetailsState {
  const TeacherStudentDetailsState();
}

class TeacherStudentDetailsInitial extends TeacherStudentDetailsState {
  const TeacherStudentDetailsInitial();
}

class TeacherStudentDetailsLoading extends TeacherStudentDetailsState {
  const TeacherStudentDetailsLoading();
}

class TeacherStudentDetailsSuccess extends TeacherStudentDetailsState {
  final TeacherStudentDetailsData data;

  const TeacherStudentDetailsSuccess(this.data);
}

class TeacherStudentDetailsError extends TeacherStudentDetailsState {
  final String message;

  const TeacherStudentDetailsError(this.message);
}

