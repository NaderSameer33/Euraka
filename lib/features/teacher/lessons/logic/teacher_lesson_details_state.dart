import '../data/models/lesson_model.dart';

abstract class TeacherLessonDetailsState {
  const TeacherLessonDetailsState();
}

class TeacherLessonDetailsInitialState extends TeacherLessonDetailsState {
  const TeacherLessonDetailsInitialState();
}

class TeacherLessonDetailsLoadingState extends TeacherLessonDetailsState {
  const TeacherLessonDetailsLoadingState();
}

class TeacherLessonDetailsSuccessState extends TeacherLessonDetailsState {
  final TeacherLessonModel lesson;
  const TeacherLessonDetailsSuccessState({required this.lesson});
}

class TeacherLessonDetailsErrorState extends TeacherLessonDetailsState {
  final String message;
  const TeacherLessonDetailsErrorState({required this.message});
}

