import 'package:equatable/equatable.dart';
import '../data/models/user_role.dart';

abstract class RoleSelectionState extends Equatable {
  final UserRole? selectedRole;

  const RoleSelectionState({this.selectedRole});

  bool get hasSelection => selectedRole != null;

  @override
  List<Object?> get props => [selectedRole];
}

class RoleSelectionInitialState extends RoleSelectionState {
  const RoleSelectionInitialState({super.selectedRole});
}

class RoleSelectionChangedState extends RoleSelectionState {
  const RoleSelectionChangedState({required super.selectedRole});
}

