import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class TeacherMainView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TeacherMainView({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      _NavItem(
        title: 'المجموعات',
        iconAsset: AppAssets.groupsNavIcon,
        branchIndex: 0,
      ),
      _NavItem(
        title: 'المواد',
        iconAsset: AppAssets.subjectNavIcon,
        branchIndex: 1,
      ),
      _NavItem(
        title: 'الرئيسيه',
        iconAsset: AppAssets.homeNavIcon,
        branchIndex: 2,
        isCenter: true,
      ),
      _NavItem(
        title: 'المهام',
        iconAsset: AppAssets.taskNavIcon,
        branchIndex: 3,
      ),
      _NavItem(
        title: 'الماليه',
        iconAsset: AppAssets.walletNavIcon,
        branchIndex: 4,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.map((item) {
              final isSelected = navigationShell.currentIndex == item.branchIndex;
              return _BottomBarItemWidget(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => _onTap(item.branchIndex),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String title;
  final String iconAsset;
  final int branchIndex;
  final bool isCenter;

  const _NavItem({
    required this.title,
    required this.iconAsset,
    required this.branchIndex,
    this.isCenter = false,
  });
}

class _BottomBarItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _BottomBarItemWidget({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF);

    Widget iconWidget = SvgPicture.asset(
      item.iconAsset,
      width: 22.sp,
      height: 22.sp,
      colorFilter: ColorFilter.mode(
        isSelected ? activeColor : inactiveColor,
        BlendMode.srcIn,
      ),
    );

    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF10281E) : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              2.verticalSpace,
              Text(
                item.title,
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: activeColor,
                ),
              ),
              2.verticalSpace,
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            4.verticalSpace,
            Text(
              item.title,
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            if (isSelected) ...[
              2.verticalSpace,
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ] else
              SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}
