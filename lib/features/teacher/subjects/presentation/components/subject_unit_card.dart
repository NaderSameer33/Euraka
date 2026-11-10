import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/subject_unit_model.dart';

class SubjectUnitCard extends StatelessWidget {
  final SubjectUnitModel unit;
  final int index;
  final VoidCallback? onTap;

  const SubjectUnitCard({
    super.key,
    required this.unit,
    this.index = 0,
    this.onTap,
  });

  static const List<Color> _badgeColors = [
    Color(0xFF2F80ED),
    Color(0xFF7B61FF),
    Color(0xFFFF9800),
    Color(0xFF00B4D8),
    Color(0xFF089B4A),
  ];

  static const List<IconData> _badgeIcons = [
    Icons.calculate_outlined,
    Icons.straighten_outlined,
    Icons.functions_outlined,
    Icons.pie_chart_outline_rounded,
    Icons.change_history_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final badgeColor = _badgeColors[index % _badgeColors.length];
    final badgeIcon = _badgeIcons[index % _badgeIcons.length];

    final subtitle = unit.description?.trim().isNotEmpty == true
        ? unit.description!.trim()
        : 'الوحدة ${unit.unitNumber}';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.35),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            badgeIcon,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                unit.title,
                                style: AppStyles.font16Bold(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              2.verticalSpace,
                              Text(
                                subtitle,
                                style: AppStyles.font12Regular(context).copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          4.horizontalSpace,
                          Text(
                            '${unit.chaptersCount} فصول',
                            style: AppStyles.font12Medium(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          8.horizontalSpace,
                          Container(
                            width: 1.w,
                            height: 10.h,
                            color: colorScheme.outline.withValues(alpha: 0.5),
                          ),
                          8.horizontalSpace,
                          Icon(
                            Icons.play_circle_outline_rounded,
                            size: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          4.horizontalSpace,
                          Text(
                            '${unit.videosCount} فيديوهات',
                            style: AppStyles.font12Medium(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 110.w,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                ),
                child: _buildUnitImage(colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitImage(ColorScheme colorScheme) {
    if (unit.photoUrl != null && unit.photoUrl!.isNotEmpty) {
      return Image.network(
        unit.photoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(colorScheme),
      );
    }
    return _buildFallbackImage(colorScheme);
  }

  Widget _buildFallbackImage(ColorScheme colorScheme) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Image.asset(
        AppAssets.unitImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 40.sp,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
