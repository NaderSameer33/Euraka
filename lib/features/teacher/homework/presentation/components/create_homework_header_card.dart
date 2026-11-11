import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class CreateHomeworkHeaderCard extends StatelessWidget {
  final String title;
  final int questionsCount;
  final int durationMinutes;
  final int totalScore;

  const CreateHomeworkHeaderCard({
    super.key,
    required this.title,
    required this.questionsCount,
    required this.durationMinutes,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.trim().isNotEmpty ? title : 'واجب بدون عنوان',
            style: AppStyles.font16Bold(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          14.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(
                context: context,
                iconPath: AppAssets.pdfIcon,
                label: '$questionsCount أسئلة',
                iconColor: AppColors.primary,
              ),
              _buildBadge(
                context: context,
                iconPath: AppAssets.timeIcon,
                label: '$durationMinutes دقيقة',
                iconColor: const Color(0xFF29B6F6),
              ),
              _buildBadge(
                context: context,
                iconPath: AppAssets.scoreIcon,
                label: '$totalScore درجة',
                iconColor: const Color(0xFFFFB300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required BuildContext context,
    required String iconPath,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 14.w,
            height: 14.h,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          6.horizontalSpace,
          Text(
            label,
            style: AppStyles.font12Medium(context).copyWith(
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
