import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../logic/teacher_add_video_cubit.dart';
import '../../logic/teacher_add_video_state.dart';

class TeacherAddLessonVideoView extends StatelessWidget {
  final String lessonId;
  final String? breadcrumb;

  const TeacherAddLessonVideoView({
    super.key,
    required this.lessonId,
    this.breadcrumb,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherAddVideoCubit(
        getIt(),
        lessonId: lessonId,
        breadcrumb: breadcrumb,
      ),
      child: const _TeacherAddLessonVideoViewBody(),
    );
  }
}

class _TeacherAddLessonVideoViewBody extends StatelessWidget {
  const _TeacherAddLessonVideoViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherAddVideoCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherAddVideoCubit, TeacherAddVideoState>(
          builder: (context, state) {
            final isLoading = state is TeacherAddVideoSubmittingState;

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
                            'اضافه فيديو جديد',
                            style: AppStyles.font18Bold(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                if (cubit.breadcrumb != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      cubit.breadcrumb!,
                      style: AppStyles.font12Medium(context).copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                12.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFieldLabel(context, 'رفع فيديو الدرس'),
                          8.verticalSpace,
                          _buildVideoBox(context, cubit, colorScheme),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'اسم الفيديو'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.nameController,
                            hintText: 'شرح المعادلات الجزء الاول',
                            validator: (val) => AppValidator.validateEmpty(val, 'اسم الفيديو'),
                          ),
                          16.verticalSpace,
                          _buildFieldLabel(context, 'الوصف (اختياري)'),
                          8.verticalSpace,
                          AppInput(
                            controller: cubit.descriptionController,
                            hintText: 'اكتب وصفا للفيديو...',
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    children: [
                      AppButton(
                        text: 'نشر الفيديو',
                        isLoading: isLoading,
                        onPressed: () async {
                          final success = await cubit.submitVideo(context);
                          if (success && context.mounted) {
                            context.pop(true);
                          }
                        },
                      ),
                      8.verticalSpace,
                      OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRouterName.teacherAddLessonMaterial,
                            extra: {
                              'lessonId': cubit.lessonId,
                              'breadcrumb': cubit.breadcrumb,
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.h),
                          side: BorderSide(color: colorScheme.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'اضافه ملفات',
                          style: AppStyles.font16Bold(context).copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildVideoBox(
    BuildContext context,
    TeacherAddVideoCubit cubit,
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

  Widget _buildGroupSelector(
    BuildContext context,
    TeacherAddVideoCubit cubit,
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
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupPicker(BuildContext context, TeacherAddVideoCubit cubit) {
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
                  'من يمكنه المشاهدة',
                  style: AppStyles.font16Bold(ctx),
                ),
                16.verticalSpace,
                if (cubit.availableGroups.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Text(
                      'لا توجد مجموعات مسجلة',
                      style: AppStyles.font14Regular(ctx),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cubit.availableGroups.length,
                      separatorBuilder: (context, index) => Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final grp = cubit.availableGroups[index];
                        final isSelected = grp.id == cubit.selectedGroupId;
                        return ListTile(
                          title: Text(
                            grp.name,
                            style: isSelected
                                ? AppStyles.font16Bold(ctx).copyWith(color: colorScheme.primary)
                                : AppStyles.font16Medium(ctx),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20.sp)
                              : null,
                          onTap: () {
                            cubit.selectGroup(grp);
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
