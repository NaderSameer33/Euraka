import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
  });

  @override
  List<Object?> get props => [themeMode, isDark];
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
