import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/academic_stage_model.dart';

class SelectGradeBottomSheet extends StatelessWidget {
  final List<AcademicStageModel> stages;
  final GradeLevelModel? selectedGrade;
  final Function(AcademicStageModel stage, GradeLevelModel grade) onSelected;

  const SelectGradeBottomSheet({
    super.key,
    required this.stages,
    required this.selectedGrade,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required List<AcademicStageModel> stages,
    required GradeLevelModel? selectedGrade,
    required Function(AcademicStageModel stage, GradeLevelModel grade) onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SelectGradeBottomSheet(
        stages: stages,
        selectedGrade: selectedGrade,
        onSelected: onSelected,
      ),
    );
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
            'اختر الصف الدراسي',
            style: AppStyles.font18Bold(context),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Expanded(
            child: ListView.separated(
              itemCount: stages.length,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, stageIndex) {
                final stage = stages[stageIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'المرحلة ${stage.nameAr}',
                        style: AppStyles.font14MediumPrimary.copyWith(
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ),
                    8.verticalSpace,
                    ...stage.grades.map((grade) {
                      final isSelected = selectedGrade?.id == grade.id;
                      return ListTile(
                        onTap: () {
                          onSelected(stage, grade);
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        tileColor: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                            : null,
                        title: Text(
                          grade.nameAr,
                          style: AppStyles.font14Regular(context).copyWith(
                            fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.regular,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
