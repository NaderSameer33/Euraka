import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_subject_model.dart';

class TeacherSubjectCard extends StatelessWidget {
  final TeacherSubjectModel subject;
  final String teacherName;
  final VoidCallback? onTap;

  const TeacherSubjectCard({
    super.key,
    required this.subject,
    required this.teacherName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradeText = subject.gradeLevel?.nameAr ?? (subject.isGlobal ? 'مادة عامة' : 'الصف الدراسي');
    final hasIconUrl =
        subject.formattedIconUrl != null &&
        subject.formattedIconUrl!.isNotEmpty &&
        !subject.formattedIconUrl!.contains('default-subject.png');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.35),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: SizedBox(
                height: 105.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasIconUrl)
                      CachedNetworkImage(
                        imageUrl: subject.formattedIconUrl!,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          decoration: BoxDecoration(
                            gradient: _getSubjectGradient(subject.nameAr),
                          ),
                          child: Center(
                            child: Icon(
                              _getSubjectIcon(subject.nameAr),
                              size: 40.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        errorWidget: (ctx, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: _getSubjectGradient(subject.nameAr),
                          ),
                          child: Center(
                            child: Icon(
                              _getSubjectIcon(subject.nameAr),
                              size: 40.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: _getSubjectGradient(subject.nameAr),
                        ),
                        child: Center(
                          child: Icon(
                            _getSubjectIcon(subject.nameAr),
                            size: 44.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    PositionedDirectional(
                      top: 8.h,
                      start: 8.w,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _getSubjectIcon(subject.nameAr),
                            size: 17.sp,
                            color: _getSubjectColor(subject.nameAr),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.displayName,
                    style: AppStyles.font14Bold(context).copyWith(
                      fontWeight: AppFontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  _buildDetailRow(
                    context: context,
                    icon: Icons.school_outlined,
                    label: gradeText,
                  ),
                  4.verticalSpace,
                  _buildDetailRow(
                    context: context,
                    icon: Icons.menu_book_outlined,
                    label: '${subject.unitsCount} وحدات',
                  ),
                  4.verticalSpace,
                  _buildDetailRow(
                    context: context,
                    icon: Icons.groups_outlined,
                    label: '${subject.groupsCount} مجموعات',
                  ),
                  4.verticalSpace,
                  _buildDetailRow(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    label: teacherName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.font12Regular(context).copyWith(
              fontSize: 10.5.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
        4.horizontalSpace,
        Icon(
          icon,
          size: 13.sp,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  LinearGradient _getSubjectGradient(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('فيزياء') || lower.contains('physics')) {
      return const LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('كيمياء') || lower.contains('chem')) {
      return const LinearGradient(
        colors: [Color(0xFF581C87), Color(0xFF9333EA), Color(0xFFC084FC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('أحياء') ||
        lower.contains('احياء') ||
        lower.contains('bio')) {
      return const LinearGradient(
        colors: [Color(0xFF065F46), Color(0xFF10B981), Color(0xFF34D399)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('رياضيات') ||
        lower.contains('math') ||
        lower.contains('جبر')) {
      return const LinearGradient(
        colors: [Color(0xFF9A3412), Color(0xFFEA580C), Color(0xFFFDBA74)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('انجليز') || lower.contains('english')) {
      return const LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF475569)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF2DD4BF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color _getSubjectColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('فيزياء') || lower.contains('physics')) {
      return const Color(0xFF2563EB);
    }
    if (lower.contains('كيمياء') || lower.contains('chem')) {
      return const Color(0xFF9333EA);
    }
    if (lower.contains('أحياء') ||
        lower.contains('احياء') ||
        lower.contains('bio')) {
      return const Color(0xFF059669);
    }
    if (lower.contains('رياضيات') ||
        lower.contains('math') ||
        lower.contains('جبر')) {
      return const Color(0xFFEA580C);
    }
    return const Color(0xFF0D9488);
  }

  IconData _getSubjectIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('فيزياء') || lower.contains('physics')) {
      return Icons.wb_sunny_outlined;
    }
    if (lower.contains('كيمياء') || lower.contains('chem')) {
      return Icons.science_outlined;
    }
    if (lower.contains('أحياء') ||
        lower.contains('احياء') ||
        lower.contains('bio')) {
      return Icons.biotech_rounded;
    }
    if (lower.contains('رياضيات') ||
        lower.contains('math') ||
        lower.contains('جبر')) {
      return Icons.calculate_outlined;
    }
    if (lower.contains('عرب') || lower.contains('لغة')) {
      return Icons.auto_stories_rounded;
    }
    if (lower.contains('حاسب') || lower.contains('computer')) {
      return Icons.computer_rounded;
    }
    return Icons.menu_book_rounded;
  }
}
