import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../groups/data/models/teacher_group_model.dart';

class SelectSubjectGroupsBottomSheet extends StatefulWidget {
  final List<TeacherGroupModel> availableGroups;
  final List<TeacherGroupModel> initialSelectedGroups;
  final Function(List<TeacherGroupModel> selected) onConfirmed;

  const SelectSubjectGroupsBottomSheet({
    super.key,
    required this.availableGroups,
    required this.initialSelectedGroups,
    required this.onConfirmed,
  });

  static Future<void> show({
    required BuildContext context,
    required List<TeacherGroupModel> availableGroups,
    required List<TeacherGroupModel> initialSelectedGroups,
    required Function(List<TeacherGroupModel> selected) onConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SelectSubjectGroupsBottomSheet(
        availableGroups: availableGroups,
        initialSelectedGroups: initialSelectedGroups,
        onConfirmed: onConfirmed,
      ),
    );
  }

  @override
  State<SelectSubjectGroupsBottomSheet> createState() =>
      _SelectSubjectGroupsBottomSheetState();
}

class _SelectSubjectGroupsBottomSheetState
    extends State<SelectSubjectGroupsBottomSheet> {
  late final List<TeacherGroupModel> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelectedGroups);
  }

  void _toggleGroup(TeacherGroupModel group) {
    setState(() {
      final exists = _selected.any((g) => g.id == group.id);
      if (exists) {
        _selected.removeWhere((g) => g.id == group.id);
      } else {
        _selected.add(group);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
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
            'تعيين المجموعات',
            style: AppStyles.font18Bold(context),
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          Text(
            'اختر المجموعات المرتبطة بهذه المادة',
            style: AppStyles.font12Regular(context),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          if (widget.availableGroups.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'لا توجد مجموعات متاحة لهذا الصف',
                  style: AppStyles.font14Regular(context),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: widget.availableGroups.length,
                separatorBuilder: (context, index) => 10.verticalSpace,
                itemBuilder: (context, index) {
                  final group = widget.availableGroups[index];
                  final isSelected = _selected.any((g) => g.id == group.id);

                  return InkWell(
                    onTap: () => _toggleGroup(group),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.08)
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.5),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            size: 22.sp,
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.name,
                                  style: AppStyles.font14Medium(context).copyWith(
                                    fontWeight: isSelected
                                        ? AppFontWeight.bold
                                        : AppFontWeight.medium,
                                  ),
                                ),
                                if (group.gradeLevelName.isNotEmpty) ...[
                                  2.verticalSpace,
                                  Text(
                                    group.gradeLevelName,
                                    style: AppStyles.font12Regular(context),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '${group.studentCount} طلاب',
                              style: AppStyles.font12Regular(context).copyWith(
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          16.verticalSpace,
          AppButton(
            text: 'تأكيد الاختيار (${_selected.length})',
            onPressed: () {
              widget.onConfirmed(_selected);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
