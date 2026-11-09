import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../../../../core/widgets/app_success_dialog.dart';
import '../../data/models/teacher_student_details_model.dart';
import '../../logic/teacher_edit_student_cubit.dart';
import '../../logic/teacher_edit_student_state.dart';
import '../components/select_grade_bottom_sheet.dart';
import '../components/teacher_delete_student_dialog.dart';

class TeacherEditStudentView extends StatelessWidget {
  final String studentId;
  final TeacherStudentDetailsData? initialData;
  final String? groupId;
  final String? groupName;

  const TeacherEditStudentView({
    super.key,
    required this.studentId,
    this.initialData,
    this.groupId,
    this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherEditStudentCubit>(
      create: (_) => getIt<TeacherEditStudentCubit>(
        param1: (
          studentId: studentId,
          initialData: initialData,
          initialGroupId: groupId,
          initialGroupName: groupName,
        ),
      ),
      child: const _TeacherEditStudentContent(),
    );
  }
}

class _TeacherEditStudentContent extends StatelessWidget {
  const _TeacherEditStudentContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherEditStudentCubit>();

    return BlocConsumer<TeacherEditStudentCubit, TeacherEditStudentState>(
      listener: (context, state) {
        if (state is TeacherEditStudentSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AppSuccessDialog(
              title: 'تم تعديل بيانات الطالب بنجاح',
              subtitle: 'تم تعديل اسم الطالب والصف الدراسي ورقم ولي الامر',
              buttonText: 'متابعه',
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pop({
                  'isUpdated': true,
                  'fullName': cubit.nameController.text.trim(),
                  'phone': cubit.phoneController.text.trim(),
                  'parentPhone': cubit.parentPhoneController.text.trim(),
                  'gradeLevelName': cubit.selectedGrade?.nameAr,
                  'isPaid': cubit.paymentStatus == 'مدفوع',
                  'paymentStatus': cubit.paymentStatus,
                });
              },
            ),
          );
        } else if (state is TeacherEditStudentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppStyles.font14Regular(context).copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is TeacherEditStudentSubmitting;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'تعديل بيانات الطالب',
              style: AppStyles.font18Bold(context),
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
            leading: Padding(
              padding: EdgeInsetsDirectional.only(start: 16.w),
              child: Center(
                child: InkWell(
                  onTap: () {
                    TeacherDeleteStudentDialog.show(
                      context,
                      onConfirm: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم استلام طلب حذف الطالب',
                              style: AppStyles.font14Regular(context).copyWith(color: Colors.white),
                            ),
                            backgroundColor: AppColors.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.pop(true);
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFEF4444),
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 86.w,
                                  height: 86.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.outline.withValues(alpha: 0.15),
                                      width: 2.w,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: cubit.avatarFile != null
                                        ? Image.file(
                                            cubit.avatarFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : (cubit.avatarUrl != null && cubit.avatarUrl!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: cubit.avatarUrl!,
                                                fit: BoxFit.cover,
                                                placeholder: (c, u) => Container(
                                                  color: colorScheme.surfaceContainerHighest,
                                                  child: const Center(child: AppLoading()),
                                                ),
                                                errorWidget: (c, u, e) => Container(
                                                  color: colorScheme.surfaceContainerHighest,
                                                  child: Icon(
                                                    Icons.person_rounded,
                                                    size: 44.sp,
                                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: colorScheme.surfaceContainerHighest,
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 44.sp,
                                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                                ),
                                              )),
                                  ),
                                ),
                                PositionedDirectional(
                                  bottom: 0,
                                  start: 0,
                                  child: InkWell(
                                    onTap: () => cubit.pickAvatar(),
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Container(
                                      width: 28.w,
                                      height: 28.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: colorScheme.surface,
                                          width: 2.w,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Center(
                            child: Text(
                              cubit.nameController.text.isNotEmpty
                                  ? cubit.nameController.text
                                  : (cubit.initialData?.studentInfo.fullName ?? ''),
                              style: AppStyles.font16Bold(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          20.verticalSpace,
                          _buildFieldLabel(context, 'اسم الطالب'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.nameController,
                            hintText: 'أدخل اسم الطالب',
                            validator: (v) => AppValidator.validateName(v),
                            onChanged: (_) => cubit.notifyListenersDirectly(),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'رقم الطالب'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.phoneController,
                            hintText: 'أدخل رقم هاتف الطالب',
                            keyboardType: TextInputType.phone,
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
                          _buildFieldLabel(context, 'الصف الدراسي'),
                          8.verticalSpace,
                          _buildSelectBox(
                            context: context,
                            hintText: 'اختر الصف',
                            valueText: cubit.selectedGrade?.nameAr ??
                                cubit.initialData?.studentInfo.gradeLevelName,
                            onTap: () {
                              SelectGradeBottomSheet.show(
                                context: context,
                                stages: cubit.stages,
                                selectedGrade: cubit.selectedGrade,
                                onSelected: (stage, grade) {
                                  cubit.selectStage(stage);
                                  cubit.selectGrade(grade);
                                },
                              );
                            },
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اختر المجموعه'),
                          8.verticalSpace,
                          _buildSelectBox(
                            context: context,
                            hintText: 'اختر المجموعة',
                            valueText: cubit.selectedGroup?.name ??
                                cubit.initialGroupName ??
                                'المجموعة',
                            onTap: () {
                              _showGroupSelectionSheet(context, cubit);
                            },
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'حاله الدفع'),
                          8.verticalSpace,
                          _buildSelectBox(
                            context: context,
                            hintText: 'حالة الدفع',
                            valueText: cubit.paymentStatus,
                            onTap: () {
                              _showPaymentStatusSheet(context, cubit);
                            },
                          ),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: AppButton(
                      text: 'تعديل',
                      isLoading: isLoading,
                      onPressed: () => cubit.submitEdit(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

  void _showGroupSelectionSheet(BuildContext context, TeacherEditStudentCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: 0.6.sh),
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
              'اختر المجموعة',
              style: AppStyles.font16Bold(context),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            if (cubit.groups.isEmpty)
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  'لا توجد مجموعات متاحة',
                  style: AppStyles.font14Regular(context),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: cubit.groups.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (ctx, index) {
                    final group = cubit.groups[index];
                    final isSelected = cubit.selectedGroup?.id == group.id;

                    return ListTile(
                      title: Text(
                        group.name,
                        style: AppStyles.font14Medium(context).copyWith(
                          color: isSelected ? AppColors.primary : colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20.sp)
                          : null,
                      onTap: () {
                        cubit.selectGroup(group);
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
  }

  void _showPaymentStatusSheet(BuildContext context, TeacherEditStudentCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const options = ['مدفوع', 'غير مدفوع'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              'حالة الدفع',
              style: AppStyles.font16Bold(context),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            ...options.map((option) {
              final isSelected = cubit.paymentStatus == option;
              return ListTile(
                title: Text(
                  option,
                  style: AppStyles.font14Medium(context).copyWith(
                    color: isSelected ? AppColors.primary : colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20.sp)
                    : null,
                onTap: () {
                  cubit.selectPaymentStatus(option);
                  Navigator.of(ctx).pop();
                },
              );
            }),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

extension on TeacherEditStudentCubit {
  void notifyListenersDirectly() {
    emit(TeacherEditStudentDataUpdated(DateTime.now().millisecondsSinceEpoch));
  }
}
