abstract class TeacherAddLessonState {
  const TeacherAddLessonState();
}

class TeacherAddLessonInitialState extends TeacherAddLessonState {
  const TeacherAddLessonInitialState();
}

class TeacherAddLessonLookupsLoadedState extends TeacherAddLessonState {
  final int version;
  const TeacherAddLessonLookupsLoadedState({required this.version});
}

class TeacherAddLessonSubmittingState extends TeacherAddLessonState {
  const TeacherAddLessonSubmittingState();
}

class TeacherAddLessonSuccessState extends TeacherAddLessonState {
  final String message;
  const TeacherAddLessonSuccessState({required this.message});
}

class TeacherAddLessonErrorState extends TeacherAddLessonState {
  final String message;
  const TeacherAddLessonErrorState({required this.message});
}

