import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/routers/app_router_name.dart';
import '../data/models/role_item_model.dart';
import '../data/models/user_role.dart';
import '../data/repos/role_selection_repo.dart';
import 'role_selection_state.dart';

class RoleSelectionCubit extends SafeCubit<RoleSelectionState> {
  final RoleSelectionRepo _repo;
  late final List<RoleItemModel> roles;

  RoleSelectionCubit(this._repo) : super(const RoleSelectionInitialState()) {
    roles = _repo.getRoles();
    final savedRole = _repo.getSavedRole();
    if (savedRole != null) {
      emit(RoleSelectionInitialState(selectedRole: savedRole));
    }
  }

  void selectRole(UserRole role) {
    emit(RoleSelectionChangedState(selectedRole: role));
  }

  Future<void> confirmRole(BuildContext context) async {
    final role = state.selectedRole;
    if (role == null) return;
    await _repo.saveRole(role);
    if (context.mounted) {
      context.go(AppRouterName.login);
    }
  }
}
