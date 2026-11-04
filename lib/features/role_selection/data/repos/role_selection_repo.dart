import 'package:flutter/material.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/role_item_model.dart';
import '../models/user_role.dart';

class RoleSelectionRepo {
  final SharedPrefService _sharedPrefService;

  RoleSelectionRepo(this._sharedPrefService);

  List<RoleItemModel> getRoles() {
    return const [
      RoleItemModel(
        role: UserRole.teacher,
        title: 'معلم / مدرس',
        subtitle: 'إدارة المجموعات، الامتحانات، رصد الدرجات، ومتابعة الطلاب بسهولة.',
        icon: Icons.school_rounded,
      ),
      RoleItemModel(
        role: UserRole.student,
        title: 'طالب',
        subtitle: 'الوصول للحصص، حل الواجبات والاختبارات، ومتابعة مستواك الدراسي.',
        icon: Icons.backpack_rounded,
      ),
    ];
  }

  Future<void> saveRole(UserRole role) async {
    await _sharedPrefService.setString(AppConstants.userRoleKey, role.value);
  }

  UserRole? getSavedRole() {
    final saved = _sharedPrefService.getString(AppConstants.userRoleKey);
    return UserRole.fromString(saved);
  }
}

