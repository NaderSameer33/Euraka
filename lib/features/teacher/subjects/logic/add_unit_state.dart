abstract class AddUnitState {
  const AddUnitState();
}

class AddUnitInitialState extends AddUnitState {
  const AddUnitInitialState();
}

class AddUnitLookupsLoadedState extends AddUnitState {
  final int version;
  const AddUnitLookupsLoadedState({required this.version});
}

class AddUnitSubmittingState extends AddUnitState {
  const AddUnitSubmittingState();
}

class AddUnitSuccessState extends AddUnitState {
  final String message;
  const AddUnitSuccessState({required this.message});
}

class AddUnitErrorState extends AddUnitState {
  final String message;
  const AddUnitErrorState({required this.message});
}

