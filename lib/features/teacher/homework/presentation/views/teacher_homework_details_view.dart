import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/homework_question_model.dart';
import '../../data/models/teacher_homework_model.dart';
import '../../logic/teacher_homework_details_cubit.dart';
import '../../logic/teacher_homework_details_state.dart';
import '../components/homework_details_question_card.dart';
import '../components/homework_details_score_card.dart';
import '../components/homework_details_summary_card.dart';

class TeacherHomeworkDetailsView extends StatelessWidget {
  final String homeworkId;

  const TeacherHomeworkDetailsView({
    super.key,
    required this.homeworkId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherHomeworkDetailsCubit>(
      create: (_) => getIt<TeacherHomeworkDetailsCubit>(param1: homeworkId)..fetchDetails(),
      child: const _TeacherHomeworkDetailsContent(),
    );
  }
}

class _TeacherHomeworkDetailsContent extends StatelessWidget {
  const _TeacherHomeworkDetailsContent();

  static final TeacherHomeworkModel _placeholderDetails = TeacherHomeworkModel(
    id: 'ph_1',
    groupId: 'grp_1',
    groupName: 'المجموعة الأولى',
    subjectName: 'الكيمياء',
    title: 'واجب الكيمياء - أعداد الكم',
    totalScore: 100,
    durationMinutes: 30,
    dueDate: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    questionsCount: 2,
    submissionsCount: 7,
    totalEnrolled: 10,
    questions: [
      HomeworkQuestionModel(
        id: 'q1',
        type: 'MCQ',
        questionText: 'ما هو عدد الكم الذي يحدد شكل السحابة الإلكترونية؟',
        options: ['الرئيسي', 'الثانوي', 'المغناطيسي', 'المغزلي'],
        correctOptionIndex: 1,
        score: 2,
        order: 1,
      ),
      HomeworkQuestionModel(
        id: 'q2',
        type: 'ESSAY',
        questionText: 'اشرح قاعدة هوند في توزيع الإلكترونات داخل الأوربيتالات بالتفصيل',
        modelAnswer: 'لا يحدث ازدواج بين إلكترونين في مستوى فرعي معين إلا بعد أن تشغل أوربيتالاته فرادى أولاً',
        score: 5,
        order: 2,
      ),
    ],
  );

  void _showDeleteConfirmation(BuildContext context, TeacherHomeworkDetailsCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            18.verticalSpace,
            Text(
              'حذف الواجب',
              style: AppStyles.font18Bold(context).copyWith(
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              'هل أنت متأكد من رغبتك في حذف هذا الواجب؟ لا يمكن التراجع عن هذا الإجراء.',
              style: AppStyles.font14Regular(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      cubit.deleteHomework();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'تأكيد الحذف',
                      style: AppStyles.font14Bold(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppStyles.font14Medium(context),
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _showSubmissionsBottomSheet(BuildContext context, TeacherHomeworkDetailsState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final submissions = state.submissions;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              'إجابات وتسليمات الطلاب',
              style: AppStyles.font18Bold(context),
              textAlign: TextAlign.center,
            ),
            14.verticalSpace,
            if (submissions.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 36.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48.r,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    12.verticalSpace,
                    Text(
                      'لا توجد تسليمات حتى الآن',
                      style: AppStyles.font14Bold(context).copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: submissions.length,
                  separatorBuilder: (context, index) => 10.verticalSpace,
                  itemBuilder: (ctx, index) {
                    final item = submissions[index] as Map<String, dynamic>?;
                    final student = item?['student'] as Map<String, dynamic>?;
                    final name = student?['fullName'] as String? ?? 'طالب ${index + 1}';
                    final score = item?['score'] ?? item?['totalScore'] ?? 0;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                child: Text(
                                  name.isNotEmpty ? name[0] : 'ط',
                                  style: AppStyles.font14Bold(context).copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Text(
                                name,
                                style: AppStyles.font14Bold(context),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '$score درجة',
                              style: AppStyles.font12Medium(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherHomeworkDetailsCubit>();

    return BlocConsumer<TeacherHomeworkDetailsCubit, TeacherHomeworkDetailsState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          HelperMethod.showErrorToast(
            context: context,
            message: state.errorMessage!,
          );
        }
        if (state.isDeleted) {
          HelperMethod.showSuccessToast(
            context: context,
            message: 'تم حذف الواجب بنجاح',
          );
          context.pop(true);
        }
      },
      builder: (context, state) {
        final homework = state.isLoading ? _placeholderDetails : state.homework;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(22.r),
                      child: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 20.r,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      'تفاصيل الواجب',
                      style: AppStyles.font18Bold(context),
                    ),
                    SizedBox(width: 44.r),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Skeletonizer(
              enabled: state.isLoading,
              effect: ShimmerEffect(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                baseColor: colorScheme.surfaceContainerHighest,
                highlightColor: colorScheme.surfaceContainer,
                duration: const Duration(milliseconds: 1400),
              ),
              child: homework == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.r,
                            color: Colors.redAccent,
                          ),
                          16.verticalSpace,
                          Text(
                            state.errorMessage ?? 'تعذر تحميل تفاصيل الواجب',
                            style: AppStyles.font16Bold(context),
                            textAlign: TextAlign.center,
                          ),
                          16.verticalSpace,
                          ElevatedButton(
                            onPressed: cubit.fetchDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HomeworkDetailsSummaryCard(
                            completedCount: homework.submissionsCount,
                            pendingCount: homework.pendingCount,
                            remainingDays: homework.remainingDays,
                          ),
                          16.verticalSpace,
                          HomeworkDetailsScoreCard(
                            highestScore: homework.totalScore > 0 ? (homework.totalScore * 0.85).round() : 85,
                            totalScore: homework.totalScore > 0 ? homework.totalScore : 100,
                          ),
                          20.verticalSpace,
                          Text(
                            'اجرائات سريعه',
                            style: AppStyles.font16Bold(context),
                          ),
                          12.verticalSpace,
                          InkWell(
                            onTap: () => _showSubmissionsBottomSheet(context, state),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'عرض اجابات الطلاب (${homework.submissionsCount})',
                                    style: AppStyles.font14Medium(context),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          ...List.generate(homework.questions.length, (idx) {
                            final q = homework.questions[idx];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: HomeworkDetailsQuestionCard(
                                index: idx,
                                question: q,
                                isCorrect: idx == 0,
                              ),
                            );
                          }),
                          24.verticalSpace,
                          ElevatedButton(
                            onPressed: () {
                              context.go(AppRouterName.teacherHome);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'العودة للرئيسية',
                              style: AppStyles.font16Bold(context).copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          12.verticalSpace,
                          ElevatedButton(
                            onPressed: state.isDeleting
                                ? null
                                : () => _showDeleteConfirmation(context, cubit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: state.isDeleting
                                ? SizedBox(
                                    width: 22.r,
                                    height: 22.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'حذف الواجب',
                                    style: AppStyles.font16Bold(context).copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
