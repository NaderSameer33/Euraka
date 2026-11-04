import 'package:flutter/material.dart';

abstract class ThemeState {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
  });
}

class ThemeInitialState extends ThemeState {
  const ThemeInitialState({
    required super.themeMode,
    required super.isDark,
  });
}

class ThemeChangedState extends ThemeState {
  const ThemeChangedState({
    required super.themeMode,
    required super.isDark,
  });
}

