import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../data/models/unit_details_response_model.dart';
import '../../logic/teacher_unit_details_cubit.dart';
import '../../logic/teacher_unit_details_state.dart';
import '../components/unit_hero_header.dart';
import '../components/unit_lesson_card.dart';

class TeacherUnitDetailsView extends StatelessWidget {
  final String unitId;
  final String? initialTitle;
  final String? initialSubjectName;

  const TeacherUnitDetailsView({
    super.key,
    required this.unitId,
    this.initialTitle,
    this.initialSubjectName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherUnitDetailsCubit(
        getIt(),
        unitId: unitId,
        initialTitle: initialTitle,
        initialSubjectName: initialSubjectName,
      ),
      child: const _TeacherUnitDetailsViewBody(),
    );
  }
}

class _TeacherUnitDetailsViewBody extends StatelessWidget {
  const _TeacherUnitDetailsViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherUnitDetailsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherUnitDetailsCubit, TeacherUnitDetailsState>(
          builder: (context, state) {
            if (state is TeacherUnitDetailsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadDetails(),
              );
            }

            final isLoading = state is TeacherUnitDetailsLoadingState;
            final data = state is TeacherUnitDetailsSuccessState
                ? state.data
                : UnitDetailsData(
                    id: '',
                    subjectId: '',
                    gradeLevelId: '',
                    title: cubit.initialTitle ?? '',
                    subjectName: cubit.initialSubjectName ?? '',
                    lessons: const [],
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
                            'تفاصيل الوحده',
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
                      onRefresh: () => cubit.loadDetails(isRefresh: true),
                      color: AppColors.primary,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        children: [
                          UnitHeroHeader(
                            title: data.title,
                            subjectName: data.subjectName,
                            lessonsCount: data.lessons.length,
                          ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الدروس',
                                style: AppStyles.font16Bold(context),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  '${data.lessons.length} دروس',
                                  style: AppStyles.font12Medium(context).copyWith(
                                    fontWeight: AppFontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          if (data.lessons.isEmpty && !isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: Text(
                                  'لا توجد دروس بعد في هذه الوحدة',
                                  style: AppStyles.font14Medium(context).copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.lessons.length,
                              separatorBuilder: (context, index) => 10.verticalSpace,
                              itemBuilder: (context, index) {
                                final lesson = data.lessons[index];
                                return UnitLessonCard(
                                  lesson: lesson,
                                  index: index,
                                  onTap: () {
                                    HelperMethod.showSuccessToast(
                                      context: context,
                                      message: lesson.title,
                                    );
                                  },
                                );
                              },
                            ),
                          16.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: AppButton(
                    text: 'اضافه درس جديد',
                    onPressed: () {
                      HelperMethod.showSuccessToast(
                        context: context,
                        message: 'سيتم فتح صفحة إضافة درس قريباً',
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
