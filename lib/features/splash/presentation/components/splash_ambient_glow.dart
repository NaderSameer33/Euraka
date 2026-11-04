import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class SplashAmbientGlow extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const SplashAmbientGlow({
    super.key,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final scale = 1.0 + (pulseAnimation.value * 0.15);
        final opacity = 0.2 + (pulseAnimation.value * 0.2);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 280.r,
            height: 280.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: opacity),
                  AppColors.primary.withValues(alpha: opacity * 0.4),
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

