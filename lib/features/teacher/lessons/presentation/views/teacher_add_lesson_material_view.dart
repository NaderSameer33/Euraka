import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../logic/teacher_add_material_cubit.dart';
import '../../logic/teacher_add_material_state.dart';

class TeacherAddLessonMaterialView extends StatelessWidget {
  final String lessonId;
  final String? breadcrumb;

  const TeacherAddLessonMaterialView({
    super.key,
    required this.lessonId,
    this.breadcrumb,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherAddMaterialCubit(
        getIt(),
        lessonId: lessonId,
        breadcrumb: breadcrumb,
      ),
      child: const _TeacherAddLessonMaterialViewBody(),
    );
  }
}

class _TeacherAddLessonMaterialViewBody extends StatelessWidget {
  const _TeacherAddLessonMaterialViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherAddMaterialCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<TeacherAddMaterialCubit, TeacherAddMaterialState>(
          listener: (context, state) {
            if (state is TeacherAddMaterialSuccessState) {
              HelperMethod.showSuccessToast(
                context: context,
                message: 'تم نشر المستند بنجاح',
              );
              context.pop(true);
            } else if (state is TeacherAddMaterialErrorState) {
              HelperMethod.showErrorToast(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is TeacherAddMaterialSubmittingState;

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
                            'اضافه ملف جديد',
                            style: AppStyles.font18Bold(context),
                          ),
                        ),
                      ),
                      40.horizontalSpace,
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              cubit.breadcrumb ?? 'رياضيات > الجبر > المعادلات الخطيه',
                              style: AppStyles.font13Medium(context).copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          _buildFieldLabel(context, 'رفع ملف شرح الدرس'),
                          8.verticalSpace,
                          _buildFileBox(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اسم الملف'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.titleController,
                            hintText: 'ملخص الدرس',
                            validator: (val) => AppValidator.validateEmpty(val, 'اسم الملف'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'الوصف (اختياري)'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'اهم النقاط في الدرس',
                            maxLines: 4,
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'من يمكنه المشاهده'),
                          8.verticalSpace,
                          _buildGroupSelector(context, cubit, colorScheme),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: AppButton(
                    text: 'نشر الملف',
                    isLoading: isLoading,
                    onPressed: cubit.submitMaterial,
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

  Widget _buildFileBox(
    BuildContext context,
    TeacherAddMaterialCubit cubit,
    ColorScheme colorScheme,
  ) {
    if (cubit.selectedFilePath != null) {
      final sizeMb = (cubit.selectedFileSizeBytes / (1024 * 1024)).toStringAsFixed(1);
      return Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colorScheme.primary, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 24.sp),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cubit.selectedFileName ?? '',
                    style: AppStyles.font14Bold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    '$sizeMb MB',
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: cubit.removeMaterialFile,
              child: Icon(Icons.close_rounded, color: AppColors.error, size: 22.sp),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: cubit.pickMaterialFile,
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_rounded,
              color: colorScheme.primary,
              size: 52.sp,
            ),
            10.verticalSpace,
            Text(
              'اسحب الملف والصق هنا',
              style: AppStyles.font16Bold(context),
            ),
            4.verticalSpace,
            Text(
              'او الصق رابط YouTube هنا',
              style: AppStyles.font12Regular(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSelector(
    BuildContext context,
    TeacherAddMaterialCubit cubit,
    ColorScheme colorScheme,
  ) {
    final title = cubit.selectedGroup?.name ?? 'جميع المجموعات';

    return GestureDetector(
      onTap: () => _showGroupPicker(context, cubit),
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
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupPicker(BuildContext context, TeacherAddMaterialCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اختر المجموعة',
                style: AppStyles.font16Bold(context),
              ),
              16.verticalSpace,
              if (cubit.groups.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Center(
                    child: Text(
                      'لا توجد مجموعات متاحة',
                      style: AppStyles.font14Medium(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: cubit.groups.length,
                    separatorBuilder: (context, index) => 8.verticalSpace,
                    itemBuilder: (context, index) {
                      final group = cubit.groups[index];
                      final isSelected = cubit.selectedGroup?.id == group.id;
                      return ListTile(
                        onTap: () {
                          cubit.selectGroup(group);
                          Navigator.pop(bottomSheetContext);
                        },
                        title: Text(
                          group.name,
                          style: AppStyles.font14Medium(context).copyWith(
                            color: isSelected ? colorScheme.primary : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                            : null,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
