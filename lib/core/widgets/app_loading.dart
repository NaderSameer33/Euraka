import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double? size;
  final Color? color;

  const AppLoading({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? AppColors.primary,
        size: size ?? 36.r,
      ),
    );
  }
}
