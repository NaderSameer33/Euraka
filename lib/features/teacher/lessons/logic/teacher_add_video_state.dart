abstract class TeacherAddVideoState {
  const TeacherAddVideoState();
}

class TeacherAddVideoInitialState extends TeacherAddVideoState {
  const TeacherAddVideoInitialState();
}

class TeacherAddVideoLookupsLoadedState extends TeacherAddVideoState {
  final int version;
  const TeacherAddVideoLookupsLoadedState({required this.version});
}

class TeacherAddVideoSubmittingState extends TeacherAddVideoState {
  const TeacherAddVideoSubmittingState();
}

class TeacherAddVideoSuccessState extends TeacherAddVideoState {
  final String message;
  const TeacherAddVideoSuccessState({required this.message});
}

class TeacherAddVideoErrorState extends TeacherAddVideoState {
  final String message;
  const TeacherAddVideoErrorState({required this.message});
}

