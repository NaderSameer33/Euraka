import '../data/models/unit_details_response_model.dart';

abstract class TeacherUnitDetailsState {
  const TeacherUnitDetailsState();
}

class TeacherUnitDetailsInitialState extends TeacherUnitDetailsState {
  const TeacherUnitDetailsInitialState();
}

class TeacherUnitDetailsLoadingState extends TeacherUnitDetailsState {
  const TeacherUnitDetailsLoadingState();
}

class TeacherUnitDetailsSuccessState extends TeacherUnitDetailsState {
  final UnitDetailsData data;
  const TeacherUnitDetailsSuccessState({required this.data});
}

class TeacherUnitDetailsErrorState extends TeacherUnitDetailsState {
  final String message;
  const TeacherUnitDetailsErrorState({required this.message});
}

