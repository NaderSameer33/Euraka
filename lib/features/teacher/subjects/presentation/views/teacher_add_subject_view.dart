import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_dashed_image_box.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../groups/presentation/components/select_grade_bottom_sheet.dart';
import '../../logic/add_subject_cubit.dart';
import '../../logic/add_subject_state.dart';
import '../components/add_chapter_dialog.dart';
import '../components/select_subject_groups_bottom_sheet.dart';
import '../components/subject_content_structure_tile.dart';

class TeacherAddSubjectView extends StatelessWidget {
  const TeacherAddSubjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddSubjectCubit>(),
      child: const _TeacherAddSubjectViewBody(),
    );
  }
}

class _TeacherAddSubjectViewBody extends StatelessWidget {
  const _TeacherAddSubjectViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<AddSubjectCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AddSubjectCubit, AddSubjectState>(
          builder: (context, state) {
            final isLoading = state is AddSubjectLoadingState;

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
                            'اضافه ماده جديده',
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
                          _buildFieldLabel(context, 'اسم الماده'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.nameController,
                            hintText: 'الرياضيات',
                            validator: (v) => AppValidator.validateEmpty(v, 'اسم المادة'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اختر الصف الدراسي'),
                          8.verticalSpace,
                          GestureDetector(
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
                            child: Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.6),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cubit.selectedGrade != null
                                        ? '${cubit.selectedStage?.nameAr ?? ''} - ${cubit.selectedGrade!.nameAr}'
                                        : 'اختر الصف',
                                    style: cubit.selectedGrade != null
                                        ? AppStyles.font14Medium(context)
                                        : AppStyles.font14Regular(context).copyWith(
                                            color: colorScheme.onSurfaceVariant,
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
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'تعيين المجموعات'),
                          8.verticalSpace,
                          _buildGroupsContainer(context, cubit),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'صوره الغلاف'),
                          8.verticalSpace,
                          AppDashedImageBox(
                            selectedImage: cubit.coverPhoto,
                            title: 'اضغط لرفع صوره الغلاف',
                            subTitle: '(5MB الحد الاقصي) JPG , PNG',
                            onTap: () => cubit.pickCoverPhoto(context),
                            onRemove: () => cubit.removeCoverPhoto(),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'وصف الماده'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'وصف بسيط للماده',
                            maxLines: 4,
                            validator: (v) => AppValidator.validateEmpty(v, 'وصف المادة'),
                          ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFieldLabel(context, 'هيكل المحتوي'),
                              GestureDetector(
                                onTap: () async {
                                  final title = await AddChapterDialog.show(
                                    context: context,
                                  );
                                  if (title != null && title.isNotEmpty) {
                                    cubit.addChapter(title);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 18.sp,
                                      color: colorScheme.primary,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      'إضافة فصل',
                                      style: AppStyles.font12MediumPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.chapters.length,
                            separatorBuilder: (context, index) => 8.verticalSpace,
                            itemBuilder: (context, index) {
                              final chapter = cubit.chapters[index];
                              return SubjectContentStructureTile(
                                title: chapter,
                                onEdit: () async {
                                  final newTitle = await AddChapterDialog.show(
                                    context: context,
                                    initialText: chapter,
                                    title: 'تعديل الفصل',
                                  );
                                  if (newTitle != null && newTitle.isNotEmpty) {
                                    cubit.editChapter(index, newTitle);
                                  }
                                },
                                onDelete: () => cubit.deleteChapter(index),
                              );
                            },
                          ),
                          24.verticalSpace,
                          AppButton(
                            text: 'نشر الماده',
                            isLoading: isLoading,
                            onPressed: () async {
                              final success = await cubit.submitSubject(context);
                              if (success && context.mounted) {
                                context.pop(true);
                              }
                            },
                          ),
                          16.verticalSpace,
                        ],
                      ),
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppStyles.font14Medium(context).copyWith(
            fontWeight: AppFontWeight.bold,
          ),
        ),
        2.horizontalSpace,
        Text(
          '*',
          style: AppStyles.font14Medium(context).copyWith(
            color: colorScheme.error,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsContainer(BuildContext context, AddSubjectCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  SelectSubjectGroupsBottomSheet.show(
                    context: context,
                    availableGroups: cubit.availableGroupsForGrade,
                    initialSelectedGroups: cubit.selectedGroups,
                    onConfirmed: (groups) {
                      cubit.setSelectedGroups(groups);
                    },
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'المجموعات المختاره',
                      style: AppStyles.font14Medium(context).copyWith(
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.add_rounded,
                      size: 16.sp,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${cubit.selectedGroups.length} مجموعات',
                  style: AppStyles.font12Regular(context).copyWith(
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          if (cubit.selectedGroups.isNotEmpty) ...[
            10.verticalSpace,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.start,
              children: cubit.selectedGroups.map((group) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        group.name,
                        style: AppStyles.font12MediumPrimary,
                      ),
                      6.horizontalSpace,
                      GestureDetector(
                        onTap: () => cubit.removeGroup(group),
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.close_rounded,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            8.verticalSpace,
            GestureDetector(
              onTap: () {
                SelectSubjectGroupsBottomSheet.show(
                  context: context,
                  availableGroups: cubit.availableGroupsForGrade,
                  initialSelectedGroups: cubit.selectedGroups,
                  onConfirmed: (groups) {
                    cubit.setSelectedGroups(groups);
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  'اضغط لتعيين المجموعات لهذه المادة',
                  style: AppStyles.font12Regular(context).copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
