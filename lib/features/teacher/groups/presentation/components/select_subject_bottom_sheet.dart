import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/academic_subject_model.dart';

class SelectSubjectBottomSheet extends StatelessWidget {
  final List<AcademicSubjectModel> subjects;
  final AcademicSubjectModel? selectedSubject;
  final ValueChanged<AcademicSubjectModel> onSelected;

  const SelectSubjectBottomSheet({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required List<AcademicSubjectModel> subjects,
    required AcademicSubjectModel? selectedSubject,
    required ValueChanged<AcademicSubjectModel> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SelectSubjectBottomSheet(
        subjects: subjects,
        selectedSubject: selectedSubject,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.verticalSpace,
          Text(
            'اختر المادة الدراسية',
            style: AppStyles.font18Bold(context),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Expanded(
            child: ListView.separated(
              itemCount: subjects.length,
              separatorBuilder: (context, index) => 8.verticalSpace,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final isSelected = selectedSubject?.id == subject.id;
                return ListTile(
                  onTap: () {
                    onSelected(subject);
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                      width: 1.0,
                    ),
                  ),
                  tileColor: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : colorScheme.surface,
                  leading: isSelected
                      ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                      : null,
                  trailing: subject.iconUrl != null && subject.iconUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: subject.iconUrl!,
                          width: 28.w,
                          height: 28.w,
                          placeholder: (context, url) => const Icon(Icons.menu_book_rounded),
                          errorWidget: (context, url, error) => const Icon(Icons.menu_book_rounded),
                        )
                      : Icon(Icons.menu_book_rounded, color: colorScheme.primary),
                  title: Text(
                    subject.nameAr,
                    style: AppStyles.font14Regular(context).copyWith(
                      fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
