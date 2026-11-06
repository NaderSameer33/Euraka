import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
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
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
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
                    isDark ? AppColors.textMutedDark : const Color(0xFF7D8391),
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
                    style: TextStyle(
                      fontFamily: AppStyles.fontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مرحبا $teacherName',
                  style: AppStyles.font16Bold(context).copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'عندك $pendingTasksCount مهام محتاجة متابعة النهارده',
                  style: AppStyles.font12Regular(context).copyWith(
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            12.horizontalSpace,
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF1E2836) : const Color(0xFFE8F5E9),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) => _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
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

