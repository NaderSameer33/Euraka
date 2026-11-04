import 'package:flutter/material.dart';
import 'user_role.dart';

class RoleItemModel {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleItemModel({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

