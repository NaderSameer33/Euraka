import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_group_model.dart';

class TeacherGroupCard extends StatelessWidget {
  final TeacherGroupModel group;
  final String teacherName;
  final VoidCallback? onTap;

  const TeacherGroupCard({
    super.key,
    required this.group,
    required this.teacherName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outline,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                  child: group.coverImageUrl != null && group.coverImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: group.coverImageUrl!,
                          height: 104.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _buildPlaceholderImage(colorScheme),
                          errorWidget: (context, url, error) => _buildPlaceholderImage(colorScheme),
                        )
                      : _buildPlaceholderImage(colorScheme),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.science_outlined,
                        size: 16.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    group.name,
                    style: AppStyles.font14Bold(context),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  _buildInfoRow(
                    icon: Icons.school_outlined,
                    text: group.gradeLevelName.isNotEmpty
                        ? group.gradeLevelName
                        : 'الصف الثالث الثانوي',
                    colorScheme: colorScheme,
                    context: context,
                  ),
                  4.verticalSpace,
                  _buildInfoRow(
                    icon: Icons.menu_book_outlined,
                    text: group.subjectName.isNotEmpty ? group.subjectName : 'فيزياء',
                    colorScheme: colorScheme,
                    context: context,
                  ),
                  4.verticalSpace,
                  _buildInfoRow(
                    icon: Icons.people_outline_rounded,
                    text: '${group.studentCount > 0 ? group.studentCount : 42} طالب',
                    colorScheme: colorScheme,
                    context: context,
                  ),
                  4.verticalSpace,
                  _buildInfoRow(
                    icon: Icons.person_outline_rounded,
                    text: teacherName,
                    colorScheme: colorScheme,
                    context: context,
                  ),
                  8.verticalSpace,
                  Divider(
                    height: 1,
                    color: colorScheme.outline,
                  ),
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            '12 مدفوع',
                            style: AppStyles.font12Regular(context).copyWith(
                              fontSize: 10.sp,
                              color: AppColors.error,
                              fontWeight: AppFontWeight.medium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            '38 مدفوع',
                            style: AppStyles.font12Regular(context).copyWith(
                              fontSize: 10.sp,
                              color: AppColors.primary,
                              fontWeight: AppFontWeight.medium,
                            ),
                          ),
                        ],
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

  Widget _buildPlaceholderImage(ColorScheme colorScheme) {
    return Container(
      height: 104.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.hub_outlined,
          size: 38.sp,
          color: colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            text,
            style: AppStyles.font12Regular(context).copyWith(
              fontSize: 10.5.sp,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        4.horizontalSpace,
        Icon(
          icon,
          size: 13.sp,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
