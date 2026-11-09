import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';

class AddGroupDashedImageBox extends StatelessWidget {
  final VoidCallback? onTap;

  const AddGroupDashedImageBox({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: colorScheme.primary.withValues(alpha: 0.6),
          strokeWidth: 1.5,
          dashWidth: 6,
          dashSpace: 4,
          borderRadius: 14.r,
        ),
        child: Container(
          width: double.infinity,
          height: 140.h,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_rounded,
                size: 44.sp,
                color: colorScheme.primary,
              ),
              10.verticalSpace,
              Text(
                'اضغط لرفع صوره المجموعه',
                style: AppStyles.font14Regular(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              4.verticalSpace,
              Text(
                'JPG , PNG (الحد الاقصى 5MB)',
                style: AppStyles.font12Regular(context).copyWith(
                  fontSize: 11.sp,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance.clamp(0.0, metric.length)),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}

