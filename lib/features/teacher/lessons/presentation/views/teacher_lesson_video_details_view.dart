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
import '../../data/models/lesson_video_details_response_model.dart';
import '../../logic/teacher_video_details_cubit.dart';
import '../../logic/teacher_video_details_state.dart';
import '../components/lesson_material_card.dart';
import '../components/lesson_video_player_box.dart';

class TeacherLessonVideoDetailsView extends StatelessWidget {
  final String videoId;
  final String? initialName;
  final String? initialBreadcrumb;

  const TeacherLessonVideoDetailsView({
    super.key,
    required this.videoId,
    this.initialName,
    this.initialBreadcrumb,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherVideoDetailsCubit(
        getIt(),
        videoId: videoId,
        initialName: initialName,
        initialBreadcrumb: initialBreadcrumb,
      ),
      child: const _TeacherLessonVideoDetailsViewBody(),
    );
  }
}

class _TeacherLessonVideoDetailsViewBody extends StatelessWidget {
  const _TeacherLessonVideoDetailsViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherVideoDetailsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherVideoDetailsCubit, TeacherVideoDetailsState>(
          builder: (context, state) {
            if (state is TeacherVideoDetailsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadVideo(),
              );
            }

            final isLoading = state is TeacherVideoDetailsLoadingState;
            final video = state is TeacherVideoDetailsSuccessState
                ? state.video
                : LessonVideoDetailsData(
                    id: cubit.videoId,
                    lessonId: '',
                    name: cubit.initialName ?? '',
                    description: '',
                    durationSeconds: 0,
                    lessonTitle: cubit.initialBreadcrumb ?? '',
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
                            'تفاصيل الفيديو',
                            style: AppStyles.font18Bold(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    video.breadcrumb.isNotEmpty ? video.breadcrumb : (cubit.initialBreadcrumb ?? ''),
                    style: AppStyles.font12Medium(context).copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: RefreshIndicator(
                      onRefresh: () => cubit.loadVideo(isRefresh: true),
                      color: AppColors.primary,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        children: [
                          LessonVideoPlayerBox(
                            videoUrl: video.formattedVideoUrl,
                            thumbnailUrl: video.formattedThumbnailUrl,
                            durationText: video.formattedDuration,
                          ),
                          16.verticalSpace,
                          Text(
                            'اسم الفيديو',
                            style: AppStyles.font14Bold(context),
                          ),
                          8.verticalSpace,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colorScheme.outline.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              video.name,
                              style: AppStyles.font14Regular(context),
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            'الوصف',
                            style: AppStyles.font14Bold(context),
                          ),
                          8.verticalSpace,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colorScheme.outline.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              video.description ?? 'لا يوجد وصف مضاف لهذا الفيديو',
                              style: AppStyles.font14Regular(context),
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            'الملفات المرفقه',
                            style: AppStyles.font14Bold(context),
                          ),
                          8.verticalSpace,
                          if (video.materials.isEmpty && !isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'لا توجد ملفات مرفقة لهذا الفيديو',
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
                              itemCount: video.materials.length,
                              separatorBuilder: (context, index) => 8.verticalSpace,
                              itemBuilder: (context, index) {
                                final mat = video.materials[index];
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
                    text: 'اضافه فيديو جديد',
                    onPressed: () {
                      context.push(
                        AppRouterName.teacherAddLessonVideo,
                        extra: {
                          'lessonId': video.lessonId,
                          'breadcrumb': video.breadcrumb,
                        },
                      );
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
