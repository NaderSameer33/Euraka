import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_dashed_image_box.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../groups/presentation/components/select_grade_bottom_sheet.dart';
import '../../logic/add_unit_cubit.dart';
import '../../logic/add_unit_state.dart';
import '../components/add_chapter_dialog.dart';
import '../components/subject_content_structure_tile.dart';
import '../components/unit_stepper_counter.dart';

class TeacherAddUnitView extends StatelessWidget {
  final String? initialSubjectId;
  final String? initialSubjectName;
  final String? initialGradeLevelId;
  final int? initialUnitNumber;

  const TeacherAddUnitView({
    super.key,
    this.initialSubjectId,
    this.initialSubjectName,
    this.initialGradeLevelId,
    this.initialUnitNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUnitCubit(
        getIt(),
        initialSubjectId: initialSubjectId,
        initialSubjectName: initialSubjectName,
        initialGradeLevelId: initialGradeLevelId,
        initialUnitNumber: initialUnitNumber,
      ),
      child: const _TeacherAddUnitViewBody(),
    );
  }
}

class _TeacherAddUnitViewBody extends StatelessWidget {
  const _TeacherAddUnitViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<AddUnitCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AddUnitCubit, AddUnitState>(
          builder: (context, state) {
            final isLoading = state is AddUnitSubmittingState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 20.sp,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'اضافه وحده جديده',
                            style: AppStyles.font18Bold(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFieldLabel(context, 'اختر الماده'),
                          8.verticalSpace,
                          _buildSubjectSelector(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'الصف الدراسي'),
                          8.verticalSpace,
                          _buildGradeSelector(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اسم الوحده'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.titleController,
                            hintText: 'الرياضيات',
                            validator: (val) => AppValidator.validateEmpty(val, 'اسم الوحدة'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'ترتيب الوحده'),
                          8.verticalSpace,
                          UnitStepperCounter(
                            value: cubit.unitNumber,
                            onIncrement: cubit.incrementUnitNumber,
                            onDecrement: cubit.decrementUnitNumber,
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'صوره الغلاف'),
                          8.verticalSpace,
                          AppDashedImageBox(
                            selectedImage: cubit.coverPhoto,
                            title: 'اضغط لرفع صوره الوحده',
                            subTitle: '(5MB الحد الاقصي) JPG , PNG',
                            onTap: () => cubit.pickCoverPhoto(context),
                            onRemove: () => cubit.removeCoverPhoto(),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'وصف الوحده'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'وصف بسيط للماده',
                            maxLines: 4,
                          ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFieldLabel(context, 'هيكل المحتوي'),
                              GestureDetector(
                                onTap: () => _openAddChapterDialog(context, cubit),
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 16.sp,
                                      color: colorScheme.primary,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      'إضافة فصل',
                                      style: AppStyles.font14Medium(context).copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          if (cubit.chapters.isEmpty)
                            GestureDetector(
                              onTap: () => _openAddChapterDialog(context, cubit),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: colorScheme.outline.withValues(alpha: 0.5),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'اضغط لإضافة فصول للوحدة',
                                  style: AppStyles.font14Regular(context).copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.chapters.length,
                              separatorBuilder: (context, index) => 8.verticalSpace,
                              itemBuilder: (context, index) {
                                final chapter = cubit.chapters[index];
                                return SubjectContentStructureTile(
                                  title: chapter,
                                  onEdit: () => _openEditChapterDialog(
                                    context,
                                    cubit,
                                    index,
                                    chapter,
                                  ),
                                  onDelete: () => cubit.deleteChapter(index),
                                );
                              },
                            ),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: AppButton(
                    text: 'نشر الوحده',
                    isLoading: isLoading,
                    onPressed: () async {
                      final success = await cubit.submitUnit(context);
                      if (success && context.mounted) {
                        context.pop(true);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppStyles.font14Medium(context),
        ),
        4.horizontalSpace,
        Text(
          '*',
          style: AppStyles.font14Medium(context).copyWith(
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSelector(
    BuildContext context,
    AddUnitCubit cubit,
    ColorScheme colorScheme,
  ) {
    final gradeTitle = cubit.selectedGrade != null
        ? '${cubit.selectedStage?.nameAr ?? ''} - ${cubit.selectedGrade!.nameAr}'
        : 'اختر الصف الدراسي';

    return GestureDetector(
      onTap: () {
        SelectGradeBottomSheet.show(
          context: context,
          stages: cubit.stages,
          selectedGrade: cubit.selectedGrade,
          onSelected: (stage, grade) {
            cubit.selectGrade(stage, grade);
          },
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                gradeTitle,
                style: cubit.selectedGrade != null
                    ? AppStyles.font14Medium(context)
                    : AppStyles.font14Regular(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector(
    BuildContext context,
    AddUnitCubit cubit,
    ColorScheme colorScheme,
  ) {
    final title = cubit.selectedSubject?.displayName ?? 'اختر المادة';

    return GestureDetector(
      onTap: () => _showSubjectPicker(context, cubit),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppStyles.font14Regular(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showSubjectPicker(BuildContext context, AddUnitCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                16.verticalSpace,
                Text(
                  'اختر المادة الدراسية',
                  style: AppStyles.font16Bold(ctx),
                ),
                16.verticalSpace,
                if (cubit.availableSubjects.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Text(
                      'لا توجد مواد مسجلة',
                      style: AppStyles.font14Regular(ctx),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cubit.availableSubjects.length,
                      separatorBuilder: (context, index) => Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final subject = cubit.availableSubjects[index];
                        final isSelected = subject.id == cubit.selectedSubjectId;
                        return ListTile(
                          title: Text(
                            subject.displayName,
                            style: isSelected
                                ? AppStyles.font16Bold(ctx).copyWith(
                                    color: colorScheme.primary,
                                  )
                                : AppStyles.font16Medium(ctx),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: colorScheme.primary,
                                  size: 20.sp,
                                )
                              : null,
                          onTap: () {
                            cubit.selectSubject(subject);
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openAddChapterDialog(BuildContext context, AddUnitCubit cubit) async {
    final title = await AddChapterDialog.show(
      context: context,
      title: 'إضافة فصل جديد',
    );
    if (title != null && title.trim().isNotEmpty) {
      cubit.addChapter(title.trim());
    }
  }

  Future<void> _openEditChapterDialog(
    BuildContext context,
    AddUnitCubit cubit,
    int index,
    String initialTitle,
  ) async {
    final title = await AddChapterDialog.show(
      context: context,
      initialText: initialTitle,
      title: 'تعديل الفصل',
    );
    if (title != null && title.trim().isNotEmpty) {
      cubit.editChapter(index, title.trim());
    }
  }
}
