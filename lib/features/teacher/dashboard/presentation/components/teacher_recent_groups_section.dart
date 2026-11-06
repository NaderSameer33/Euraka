import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_font_weight.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_dashboard_response_model.dart';

class TeacherRecentGroupsSection extends StatelessWidget {
  final List<TeacherRecentGroupModel> groups;
  final VoidCallback? onViewAllPressed;

  const TeacherRecentGroupsSection({
    super.key,
    required this.groups,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'مجموعاتي',
              style: AppStyles.font16Bold(context).copyWith(
                fontWeight: AppFontWeight.extraBold,
              ),
            ),
            GestureDetector(
              onTap: onViewAllPressed ?? () {},
              child: Text(
                'عرض الكل',
                style: AppStyles.font14MediumPrimary.copyWith(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        if (groups.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Text(
              'لا توجد مجموعات حالية',
              style: AppStyles.font14Regular(context).copyWith(
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          )
        else
          ...groups.map((group) => _GroupCard(group: group)),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  final TeacherRecentGroupModel group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2836) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  group.coverImageUrl != null && group.coverImageUrl!.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: group.coverImageUrl!,
                        width: 44.w,
                        height: 44.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const _SubjectIcon(),
                        errorWidget: (context, url, error) => const _SubjectIcon(),
                      ),
                    )
                  : const _SubjectIcon(),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  group.name,
                  style: AppStyles.font14Bold(context).copyWith(
                    color: isDark ? AppColors.white : const Color(0xFF13181D),
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'آخر نشاط منذ يوم',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.access_time_rounded,
                      size: 13.sp,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF9CA3AF),
                    ),
                    12.horizontalSpace,
                    Text(
                      '${group.studentCount} طالب',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.people_outline_rounded,
                      size: 14.sp,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectIcon extends StatelessWidget {
  const _SubjectIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.science_outlined,
      size: 24.sp,
      color: const Color(0xFF3B82F6),
    );
  }
}
