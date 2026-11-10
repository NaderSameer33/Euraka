import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../data/models/lesson_model.dart';
import '../../logic/teacher_lesson_details_cubit.dart';
import '../../logic/teacher_lesson_details_state.dart';
import '../components/lesson_hero_header.dart';
import '../components/lesson_material_card.dart';
import '../components/lesson_video_card.dart';

class TeacherLessonDetailsView extends StatelessWidget {
  final String lessonId;

  const TeacherLessonDetailsView({
    super.key,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherLessonDetailsCubit(
        getIt(),
        lessonId: lessonId,
      ),
      child: const _TeacherLessonDetailsViewBody(),
    );
  }
}

class _TeacherLessonDetailsViewBody extends StatelessWidget {
  const _TeacherLessonDetailsViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherLessonDetailsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherLessonDetailsCubit, TeacherLessonDetailsState>(
          builder: (context, state) {
            if (state is TeacherLessonDetailsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadLesson(),
              );
            }

            final isLoading = state is TeacherLessonDetailsLoadingState;
            final lesson = state is TeacherLessonDetailsSuccessState
                ? state.lesson
                : const TeacherLessonModel(
                    id: '',
                    unitId: '',
                    name: '',
                    title: '',
                    subjectName: '',
                    unitTitle: '',
                  );

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
                            'تفاصيل الدرس',
                            style: AppStyles.font18Bold(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                Expanded(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: RefreshIndicator(
                      onRefresh: () => cubit.loadLesson(isRefresh: true),
                      color: AppColors.primary,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        children: [
                          LessonHeroHeader(
                            title: lesson.displayName,
                            breadcrumb: lesson.breadcrumb,
                            count: lesson.videoCount,
                            countLabel: 'فيديوهات',
                          ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الفيديوهات (${lesson.videos.length})',
                                style: AppStyles.font16Bold(context),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final added = await context.push<bool>(
                                    AppRouterName.teacherAddLessonVideo,
                                    extra: {
                                      'lessonId': cubit.lessonId,
                                      'breadcrumb': lesson.breadcrumb,
                                    },
                                  );
                                  if (added == true) {
                                    cubit.loadLesson(isRefresh: true);
                                  }
                                },
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
                                      'إضافة فيديو',
                                      style: AppStyles.font12Medium(context).copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          if (lesson.videos.isEmpty && !isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'لا توجد فيديوهات مضافة بعد',
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
                              itemCount: lesson.videos.length,
                              separatorBuilder: (context, index) => 10.verticalSpace,
                              itemBuilder: (context, index) {
                                final vid = lesson.videos[index];
                                return LessonVideoCard(
                                  video: vid,
                                  index: index,
                                  chapterTitle: lesson.unitTitle,
                                  onTap: () {
                                    context.push(
                                      AppRouterName.teacherLessonVideoDetails,
                                      extra: {
                                        'videoId': vid.id,
                                        'name': vid.name,
                                        'breadcrumb': lesson.breadcrumb,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الملفات (${lesson.materials.length})',
                                style: AppStyles.font16Bold(context),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final added = await context.push<bool>(
                                    AppRouterName.teacherAddLessonMaterial,
                                    extra: {
                                      'lessonId': cubit.lessonId,
                                      'breadcrumb': lesson.breadcrumb,
                                    },
                                  );
                                  if (added == true) {
                                    cubit.loadLesson(isRefresh: true);
                                  }
                                },
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
                                      'إضافة ملف',
                                      style: AppStyles.font12Medium(context).copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          if (lesson.materials.isEmpty && !isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'لا توجد ملفات مرفقة بعد',
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
                              itemCount: lesson.materials.length,
                              separatorBuilder: (context, index) => 8.verticalSpace,
                              itemBuilder: (context, index) {
                                final mat = lesson.materials[index];
                                return LessonMaterialCard(
                                  material: mat,
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
                    text: 'اضافه ملف جديد',
                    onPressed: () async {
                      final added = await context.push<bool>(
                        AppRouterName.teacherAddLessonMaterial,
                        extra: {
                          'lessonId': cubit.lessonId,
                          'breadcrumb': lesson.breadcrumb,
                        },
                      );
                      if (added == true) {
                        cubit.loadLesson(isRefresh: true);
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
}
