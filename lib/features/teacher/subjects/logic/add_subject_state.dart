import 'package:equatable/equatable.dart';
import '../data/models/teacher_subject_model.dart';

abstract class AddSubjectState extends Equatable {
  const AddSubjectState();

  @override
  List<Object?> get props => [];
}

class AddSubjectInitialState extends AddSubjectState {
  const AddSubjectInitialState();
}

class AddSubjectLookupsLoadedState extends AddSubjectState {
  final int version;

  const AddSubjectLookupsLoadedState({required this.version});

  @override
  List<Object?> get props => [version];
}

class AddSubjectLoadingState extends AddSubjectState {
  const AddSubjectLoadingState();
}

class AddSubjectSuccessState extends AddSubjectState {
  final TeacherSubjectModel? createdSubject;

  const AddSubjectSuccessState({this.createdSubject});

  @override
  List<Object?> get props => [createdSubject];
}

class AddSubjectErrorState extends AddSubjectState {
  final String message;

  const AddSubjectErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
