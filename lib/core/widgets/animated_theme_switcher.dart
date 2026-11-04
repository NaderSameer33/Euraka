import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/get_it_service.dart';
import '../theme/app_colors.dart';
import '../theme/logic/theme_cubit.dart';

class AnimatedThemeSwitcher extends StatelessWidget {
  final double? width;
  final double? height;

  const AnimatedThemeSwitcher({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final themeCubit = getIt<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc: themeCubit,
      builder: (context, themeMode) {
        final isDark = themeCubit.isDarkMode;
        final switcherWidth = width ?? 62.w;
        final switcherHeight = height ?? 34.h;
        final knobSize = switcherHeight - 6.h;

        return GestureDetector(
          onTap: themeCubit.toggleTheme,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            width: switcherWidth,
            height: switcherHeight,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(switcherHeight / 2),
              color: isDark ? const Color(0xFF1E2638) : const Color(0xFFE8F5E9),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2C3B55)
                    : AppColors.primary.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutBack,
                  alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        turns: isDark ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutBack,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            isDark
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            key: ValueKey<bool>(isDark),
                            size: 16.sp,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

