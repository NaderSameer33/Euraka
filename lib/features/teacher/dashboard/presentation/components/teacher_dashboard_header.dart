import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_font_weight.dart';
import '../../../../../../core/theme/app_styles.dart';

class TeacherDashboardHeader extends StatelessWidget {
  final String teacherName;
  final int pendingTasksCount;
  final String? avatarUrl;

  const TeacherDashboardHeader({
    super.key,
    required this.teacherName,
    this.pendingTasksCount = 3,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: AppConstants.formatImageUrl(avatarUrl) != null
                    ? CachedNetworkImage(
                        imageUrl: AppConstants.formatImageUrl(avatarUrl)!,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildDefaultAvatar(),
                        errorWidget: (context, url, error) => _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مرحبا $teacherName',
                  style: AppStyles.font16Bold(context).copyWith(
                    fontWeight: AppFontWeight.extraBold,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'عندك $pendingTasksCount مهام محتاجة متابعة النهارده',
                  style: AppStyles.font12Regular(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
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
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.bellIcon,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: AppStyles.font12Medium(context).copyWith(
                      fontSize: 10.sp,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.12),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: AppColors.primary,
          size: 28.sp,
        ),
      ),
    );
  }
}
