import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_task_card_model.dart';

class TasksTabBar extends StatelessWidget {
  final TaskCategoryType selectedCategory;
  final ValueChanged<TaskCategoryType> onCategorySelected;

  const TasksTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categories = TaskCategoryType.values;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () => onCategorySelected(cat),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Text(
                    cat.title,
                    style: AppStyles.font14Bold(context).copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  height: 3.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

