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
import '../../../../../core/widgets/app_input.dart';
import '../../logic/add_group_cubit.dart';
import '../../logic/add_group_state.dart';
import '../components/add_group_dashed_image_box.dart';
import '../components/select_grade_bottom_sheet.dart';
import '../components/select_subject_bottom_sheet.dart';

class TeacherAddGroupView extends StatelessWidget {
  const TeacherAddGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddGroupCubit>(),
      child: const _TeacherAddGroupViewBody(),
    );
  }
}

class _TeacherAddGroupViewBody extends StatelessWidget {
  const _TeacherAddGroupViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<AddGroupCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AddGroupCubit, AddGroupState>(
          builder: (context, state) {
            final isLoading = state is AddGroupLoadingState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 40.w),
                      Text(
                        'اضافه مجموعه',
                        style: AppStyles.font18Bold(context),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
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
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildFieldLabel(context, 'اسم المجموعه'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.nameController,
                            hintText: 'مجموعه أ',
                            validator: (v) => AppValidator.validateEmpty(v, 'اسم المجموعة'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اختر الصف الدراسي'),
                          8.verticalSpace,
                          _buildSelectBox(
                            context: context,
                            hintText: 'اختر الصف',
                            valueText: cubit.selectedGrade?.nameAr,
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
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'صوره المجموعه'),
                          8.verticalSpace,
                          AddGroupDashedImageBox(
                            onTap: () {},
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اختر الماده'),
                          8.verticalSpace,
                          _buildSelectBox(
                            context: context,
                            hintText: 'فيزياء',
                            valueText: cubit.selectedSubject?.nameAr,
                            onTap: () {
                              SelectSubjectBottomSheet.show(
                                context: context,
                                subjects: cubit.subjects,
                                selectedSubject: cubit.selectedSubject,
                                onSelected: (subject) {
                                  cubit.selectSubject(subject);
                                },
                              );
                            },
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اسم المدرس'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.teacherNameController,
                            hintText: 'محمد احمد',
                            validator: (v) => AppValidator.validateEmpty(v, 'اسم المدرس'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'وصف المجموعه'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'وصف بسيط للمجموعه',
                            maxLines: 4,
                            validator: (v) => AppValidator.validateEmpty(v, 'وصف المجموعة'),
                          ),
                          24.verticalSpace,
                          AppButton(
                            text: 'انشاء المجموعه',
                            height: 50.h,
                            borderRadius: 12.r,
                            isLoading: isLoading,
                            textStyle: AppStyles.font16BoldWhite,
                            onPressed: () => cubit.createGroup(context),
                          ),
                          24.verticalSpace,
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

  Widget _buildFieldLabel(BuildContext context, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '*',
          style: AppStyles.font14Bold(context).copyWith(
            color: AppColors.error,
          ),
        ),
        4.horizontalSpace,
        Text(
          text,
          style: AppStyles.font14Bold(context).copyWith(
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectBox({
    required BuildContext context,
    required String hintText,
    required String? valueText,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasValue = valueText != null && valueText.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: colorScheme.outline,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            Text(
              hasValue ? valueText : hintText,
              style: AppStyles.font14Regular(context).copyWith(
                color: hasValue ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
