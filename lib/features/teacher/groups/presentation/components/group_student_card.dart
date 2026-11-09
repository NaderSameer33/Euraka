import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/group_student_model.dart';

class GroupStudentCard extends StatelessWidget {
  final GroupStudentModel student;
  final VoidCallback? onTap;

  const GroupStudentCard({
    super.key,
    required this.student,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPaid = student.isPaid || student.paymentStatus == 'مدفوع';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
        child: Row(
          children: [
            Icon(
              Icons.chevron_left_rounded,
              size: 22.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  student.fullName,
                  style: AppStyles.font14Bold(context),
                  textAlign: TextAlign.right,
                ),
                4.verticalSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.phone,
                      style: AppStyles.font12Regular(context),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.phone_outlined,
                      size: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                6.verticalSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isPaid ? 'مدفوع' : 'غير مدفوع',
                      style: AppStyles.font12Regular(context).copyWith(
                        fontSize: 11.sp,
                        color: isPaid ? AppColors.primary : AppColors.error,
                        fontWeight: AppFontWeight.medium,
                      ),
                    ),
                    4.horizontalSpace,
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isPaid ? AppColors.primary : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            12.horizontalSpace,
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 1.0,
                ),
              ),
              child: ClipOval(
                child: student.avatarUrl != null &&
                        student.avatarUrl!.isNotEmpty &&
                        !student.avatarUrl!.contains('default-avatar')
                    ? CachedNetworkImage(
                        imageUrl: student.avatarUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildDefaultAvatar(colorScheme),
                        errorWidget: (context, url, error) => _buildDefaultAvatar(colorScheme),
                      )
                    : _buildDefaultAvatar(colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 30.sp,
        color: colorScheme.primary,
      ),
    );
  }
}

