import '../data/models/lesson_video_details_response_model.dart';

abstract class TeacherVideoDetailsState {
  const TeacherVideoDetailsState();
}

class TeacherVideoDetailsInitialState extends TeacherVideoDetailsState {
  const TeacherVideoDetailsInitialState();
}

class TeacherVideoDetailsLoadingState extends TeacherVideoDetailsState {
  const TeacherVideoDetailsLoadingState();
}

class TeacherVideoDetailsSuccessState extends TeacherVideoDetailsState {
  final LessonVideoDetailsData video;
  const TeacherVideoDetailsSuccessState({required this.video});
}

class TeacherVideoDetailsErrorState extends TeacherVideoDetailsState {
  final String message;
  const TeacherVideoDetailsErrorState({required this.message});
}

