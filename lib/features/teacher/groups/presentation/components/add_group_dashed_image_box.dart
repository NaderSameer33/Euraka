import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';

class AddGroupDashedImageBox extends StatelessWidget {
  final File? selectedImage;
  final String title;
  final String subTitle;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const AddGroupDashedImageBox({
    super.key,
    this.selectedImage,
    this.title = 'اضغط لرفع صوره المجموعه',
    this.subTitle = 'JPG , PNG (الحد الاقصى 5MB)',
    this.height,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final boxHeight = height ?? 140.h;

    if (selectedImage != null) {
      return Container(
        width: double.infinity,
        height: boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'تغيير الصورة',
                          style: AppStyles.font12Regular(context).copyWith(
                            color: Colors.white,
                            fontWeight: AppFontWeight.medium,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'تم اختيار الصورة',
                          style: AppStyles.font12Regular(context).copyWith(
                            color: Colors.white,
                            fontWeight: AppFontWeight.semiBold,
                          ),
                        ),
                        6.horizontalSpace,
                        Icon(
                          Icons.check_circle_rounded,
                          color: colorScheme.primary,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
          height: boxHeight,
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
                size: 40.sp,
                color: colorScheme.primary,
              ),
              10.verticalSpace,
              Text(
                title,
                style: AppStyles.font14Regular(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              4.verticalSpace,
              Text(
                subTitle,
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
