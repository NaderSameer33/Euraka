import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emptyColor = theme.colorScheme.outline.withValues(alpha: 0.25);

    Color activeColor;
    String label;
    int filledBars;

    if (strength <= 0.0) {
      activeColor = emptyColor;
      label = '';
      filledBars = 0;
    } else if (strength < 0.5) {
      activeColor = AppColors.error;
      label = 'ضعيفه';
      filledBars = 1;
    } else if (strength < 0.9) {
      activeColor = const Color(0xFFFFA000);
      label = 'متوسطه';
      filledBars = 2;
    } else {
      activeColor = AppColors.primary;
      label = 'قويه';
      filledBars = 4;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: List.generate(4, (index) {
              final isFilled = index < filledBars;
              return Container(
                margin: EdgeInsets.only(right: index < 3 ? 6.w : 0),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isFilled ? activeColor : emptyColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              );
            }),
          ),
        ),
        if (label.isNotEmpty)
          Row(
            children: [
              Text(
                'قوه كلمه المرور : ',
                style: AppStyles.font12Regular(context),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

