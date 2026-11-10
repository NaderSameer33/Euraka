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
import '../../../../../core/widgets/app_input.dart';
import '../../../subjects/presentation/components/unit_stepper_counter.dart';
import '../../logic/teacher_add_lesson_cubit.dart';
import '../../logic/teacher_add_lesson_state.dart';

class TeacherAddLessonView extends StatelessWidget {
  final String? initialSubjectId;
  final String? initialUnitId;
  final int? initialLessonOrder;

  const TeacherAddLessonView({
    super.key,
    this.initialSubjectId,
    this.initialUnitId,
    this.initialLessonOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherAddLessonCubit(
        getIt(),
        initialSubjectId: initialSubjectId,
        initialUnitId: initialUnitId,
        initialLessonOrder: initialLessonOrder,
      ),
      child: const _TeacherAddLessonViewBody(),
    );
  }
}

class _TeacherAddLessonViewBody extends StatelessWidget {
  const _TeacherAddLessonViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherAddLessonCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherAddLessonCubit, TeacherAddLessonState>(
          builder: (context, state) {
            final isLoading = state is TeacherAddLessonSubmittingState;

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
                            'اضافه درس جديد',
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
                          _buildFieldLabel(context, 'اختر الوحده'),
                          8.verticalSpace,
                          _buildUnitSelector(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'عنوان الدرس'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.titleController,
                            hintText: 'مقدمه في الجبر',
                            validator: (val) => AppValidator.validateEmpty(val, 'عنوان الدرس'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'ترتيب الدرس'),
                          8.verticalSpace,
                          UnitStepperCounter(
                            value: cubit.lessonOrder,
                            onIncrement: cubit.incrementOrder,
                            onDecrement: cubit.decrementOrder,
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'رفع فيديو الدرس'),
                          8.verticalSpace,
                          _buildVideoBox(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اضافه مرفقات'),
                          8.verticalSpace,
                          _buildAttachmentsSection(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'محتوي الدرس بالتفصيل'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'اكتب شرح الدرس بالتفصيل',
                            maxLines: 4,
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
                    text: 'نشر الدرس',
                    isLoading: isLoading,
                    onPressed: () async {
                      final success = await cubit.submitLesson(context);
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

  Widget _buildSubjectSelector(
    BuildContext context,
    TeacherAddLessonCubit cubit,
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

  Widget _buildUnitSelector(
    BuildContext context,
    TeacherAddLessonCubit cubit,
    ColorScheme colorScheme,
  ) {
    final title = cubit.selectedUnit?.title ?? 'الوحده تفلتر حسب الماده';

    return GestureDetector(
      onTap: () => _showUnitPicker(context, cubit),
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

  Widget _buildVideoBox(
    BuildContext context,
    TeacherAddLessonCubit cubit,
    ColorScheme colorScheme,
  ) {
    if (cubit.selectedVideo != null) {
      final fileName = cubit.selectedVideo!.path.split(RegExp(r'[/\\]')).last;
      return Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colorScheme.primary, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.movie_creation_outlined, color: colorScheme.primary, size: 28.sp),
            12.horizontalSpace,
            Expanded(
              child: Text(
                fileName,
                style: AppStyles.font14Bold(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () => cubit.removeVideo(),
              child: Icon(Icons.close_rounded, color: AppColors.error, size: 22.sp),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => cubit.pickVideo(context),
      child: Container(
        height: 140.h,
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
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32.sp),
            ),
            10.verticalSpace,
            Text(
              'اضغط لرفع الفيديو',
              style: AppStyles.font14Bold(context),
            ),
            4.verticalSpace,
            Text(
              '(500MB الحد الاقصي) MP4 , MOV',
              style: AppStyles.font12Regular(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(
    BuildContext context,
    TeacherAddLessonCubit cubit,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        if (cubit.attachments.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cubit.attachments.length,
            separatorBuilder: (context, index) => 8.verticalSpace,
            itemBuilder: (context, index) {
              final file = cubit.attachments[index];
              final name = file.path.split(RegExp(r'[/\\]')).last;
              final isPdf = name.toLowerCase().endsWith('.pdf');
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: isPdf
                            ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isPdf ? 'PDF' : 'IMG',
                        style: TextStyle(
                          color: isPdf ? const Color(0xFFEF4444) : AppColors.primary,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        name,
                        style: AppStyles.font14Regular(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cubit.removeAttachment(index),
                      child: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
                    ),
                  ],
                ),
              );
            },
          ),
        8.verticalSpace,
        GestureDetector(
          onTap: () => cubit.pickAttachments(),
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.primary, width: 1.0),
            ),
            alignment: Alignment.center,
            child: Text(
              'اضافه ملفات اخري',
              style: AppStyles.font14Bold(context).copyWith(color: colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  void _showSubjectPicker(BuildContext context, TeacherAddLessonCubit cubit) {
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
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: cubit.availableSubjects.length,
                    separatorBuilder: (context, index) => Divider(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final sub = cubit.availableSubjects[index];
                      final isSelected = sub.id == cubit.selectedSubjectId;
                      return ListTile(
                        title: Text(
                          sub.displayName,
                          style: isSelected
                              ? AppStyles.font16Bold(ctx).copyWith(color: colorScheme.primary)
                              : AppStyles.font16Medium(ctx),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20.sp)
                            : null,
                        onTap: () {
                          cubit.selectSubject(sub);
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

  void _showUnitPicker(BuildContext context, TeacherAddLessonCubit cubit) {
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
                  'اختر الوحدة الدراسية',
                  style: AppStyles.font16Bold(ctx),
                ),
                16.verticalSpace,
                if (cubit.availableUnits.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Text(
                      'لا توجد وحدات مضافة بعد لهذه المادة',
                      style: AppStyles.font14Regular(ctx),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cubit.availableUnits.length,
                      separatorBuilder: (context, index) => Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final unit = cubit.availableUnits[index];
                        final isSelected = unit.id == cubit.selectedUnitId;
                        return ListTile(
                          title: Text(
                            unit.title,
                            style: isSelected
                                ? AppStyles.font16Bold(ctx).copyWith(color: colorScheme.primary)
                                : AppStyles.font16Medium(ctx),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20.sp)
                              : null,
                          onTap: () {
                            cubit.selectUnit(unit);
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
}
