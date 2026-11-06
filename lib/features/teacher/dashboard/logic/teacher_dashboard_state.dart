import 'package:equatable/equatable.dart';
import '../data/models/teacher_dashboard_response_model.dart';

abstract class TeacherDashboardState extends Equatable {
  const TeacherDashboardState();

  @override
  List<Object?> get props => [];
}

class TeacherDashboardInitialState extends TeacherDashboardState {
  const TeacherDashboardInitialState();
}

class TeacherDashboardLoadingState extends TeacherDashboardState {
  const TeacherDashboardLoadingState();
}

class TeacherDashboardSuccessState extends TeacherDashboardState {
  final TeacherDashboardData data;
  final String teacherName;
  final String? avatarUrl;

  const TeacherDashboardSuccessState({
    required this.data,
    this.teacherName = 'أ/ أحمد',
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [data, teacherName, avatarUrl];
}

class TeacherDashboardErrorState extends TeacherDashboardState {
  final String message;

  const TeacherDashboardErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
