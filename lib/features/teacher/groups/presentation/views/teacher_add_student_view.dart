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
import '../../logic/add_student_cubit.dart';
import '../../logic/add_student_state.dart';
import '../components/add_group_dashed_image_box.dart';
import '../components/select_grade_bottom_sheet.dart';

class TeacherAddStudentView extends StatelessWidget {
  final String groupId;
  final String? groupName;

  const TeacherAddStudentView({
    super.key,
    required this.groupId,
    this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddStudentCubit>(
        param1: (groupId: groupId, defaultPrice: 300),
      ),
      child: const _TeacherAddStudentViewBody(),
    );
  }
}

class _TeacherAddStudentViewBody extends StatelessWidget {
  const _TeacherAddStudentViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<AddStudentCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AddStudentCubit, AddStudentState>(
          builder: (context, state) {
            final isLoading = state is AddStudentLoadingState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
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
                              Icons.arrow_back_rounded,
                              size: 20.sp,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'اضافه طالب',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(context, 'اسم الطالب'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.fullNameController,
                            hintText: 'أدخل اسم الطالب',
                            validator: (v) => AppValidator.validateName(v),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'رقم الطالب'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.phoneController,
                            hintText: 'أدخل رقم هاتف الطالب',
                            keyboardType: TextInputType.phone,
                            validator: (v) => AppValidator.validatePhone(v),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'صوره الطالب'),
                          8.verticalSpace,
                          AddGroupDashedImageBox(
                            selectedImage: cubit.photoFile,
                            title: 'اضغط لرفع صوره الطالب',
                            subTitle: 'JPG , PNG (الحد الاقصى 5MB)',
                            height: 140.h,
                            onTap: () => cubit.pickStudentPhoto(context),
                            onRemove: () => cubit.removeStudentPhoto(),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'رقم ولي الامر'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.parentPhoneController,
                            hintText: 'أدخل رقم هاتف ولي الأمر',
                            keyboardType: TextInputType.phone,
                            validator: (v) => AppValidator.validatePhone(v),
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
                          if (cubit.selectedStage != null &&
                              cubit.selectedStage!.grades.isNotEmpty)
                            _buildInlineGradesList(context, cubit),
                          24.verticalSpace,
                          AppButton(
                            text: 'اضافه الطالب',
                            height: 50.h,
                            borderRadius: 12.r,
                            isLoading: isLoading,
                            textStyle: AppStyles.font16BoldWhite,
                            onPressed: () => cubit.addStudent(context),
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
          text,
          style: AppStyles.font14Bold(context).copyWith(
            fontWeight: AppFontWeight.bold,
          ),
        ),
        4.horizontalSpace,
        Text(
          '*',
          style: AppStyles.font14Bold(context).copyWith(
            color: AppColors.error,
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
            Text(
              hasValue ? valueText : hintText,
              style: AppStyles.font14Regular(context).copyWith(
                color: hasValue ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineGradesList(BuildContext context, AddStudentCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grades = cubit.selectedStage?.grades ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: grades.map((grade) {
          final isSelected = cubit.selectedGrade?.id == grade.id;
          return InkWell(
            onTap: () => cubit.selectGrade(cubit.selectedStage!, grade),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      color: colorScheme.primary,
                      size: 20.sp,
                    )
                  else
                    SizedBox(width: 20.sp),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      grade.nameAr,
                      style: AppStyles.font14Regular(context).copyWith(
                        fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

