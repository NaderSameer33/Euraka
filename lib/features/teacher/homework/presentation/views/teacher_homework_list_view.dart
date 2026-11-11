import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_homework_model.dart';
import '../../logic/teacher_homework_list_cubit.dart';
import '../../logic/teacher_homework_list_state.dart';
import '../components/teacher_homework_card.dart';

class TeacherHomeworkListView extends StatefulWidget {
  const TeacherHomeworkListView({super.key});

  @override
  State<TeacherHomeworkListView> createState() => _TeacherHomeworkListViewState();
}

class _TeacherHomeworkListViewState extends State<TeacherHomeworkListView> {
  static List<TeacherHomeworkModel> get _placeholderHomeworks => List.generate(
        3,
        (i) => TeacherHomeworkModel(
          id: 'placeholder_$i',
          groupId: 'grp_$i',
          groupName: 'المجموعة الأولى - رياضيات',
          subjectName: 'الرياضيات',
          title: 'واجب المعادلات الخطية والمتباينات',
          totalScore: 20,
          durationMinutes: 30,
          dueDate: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          questionsCount: 5,
          submissionsCount: 12,
          totalEnrolled: 25,
        ),
      );

  @override
  void initState() {
    super.initState();
    context.read<TeacherHomeworkListCubit>().fetchHomeworks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherHomeworkListCubit>();

    return BlocConsumer<TeacherHomeworkListCubit, TeacherHomeworkListState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          HelperMethod.showErrorToast(
            context: context,
            message: state.errorMessage!,
          );
        }
        if (state.deleteSuccessMessage != null && state.deleteSuccessMessage!.isNotEmpty) {
          HelperMethod.showSuccessToast(
            context: context,
            message: state.deleteSuccessMessage!,
          );
        }
      },
      builder: (context, state) {
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
                      'الواجبات المدرسية',
                      style: AppStyles.font18Bold(context),
                    ),
                    InkWell(
                      onTap: () async {
                        await context.push(AppRouterName.teacherCreateHomework);
                        cubit.fetchHomeworks();
                      },
                      borderRadius: BorderRadius.circular(22.r),
                      child: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 24.r,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => cubit.fetchHomeworks(),
              color: AppColors.primary,
              child: Skeletonizer(
                enabled: state.isLoading,
                effect: ShimmerEffect(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  baseColor: colorScheme.surfaceContainerHighest,
                  highlightColor: colorScheme.surfaceContainer,
                  duration: const Duration(milliseconds: 1400),
                ),
                child: state.isLoading
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        itemCount: _placeholderHomeworks.length,
                        separatorBuilder: (context, index) => 14.verticalSpace,
                        itemBuilder: (context, index) {
                          return TeacherHomeworkCard(
                            homework: _placeholderHomeworks[index],
                            onTap: () {},
                            onDelete: () {},
                          );
                        },
                      )
                    : state.homeworks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 64.r,
                                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                                16.verticalSpace,
                                Text(
                                  'لا توجد واجبات حالياً',
                                  style: AppStyles.font16Bold(context).copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                8.verticalSpace,
                                Text(
                                  'قم بإضافة واجب جديد لتظهر هنا',
                                  style: AppStyles.font13Regular(context),
                                ),
                                24.verticalSpace,
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await context.push(AppRouterName.teacherCreateHomework);
                                    cubit.fetchHomeworks();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                                  label: Text(
                                    'اضافه واجب جديد',
                                    style: AppStyles.font14Bold(context).copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            itemCount: state.homeworks.length,
                            separatorBuilder: (context, index) => 14.verticalSpace,
                            itemBuilder: (context, index) {
                              final homework = state.homeworks[index];
                              return TeacherHomeworkCard(
                                homework: homework,
                                onTap: () async {
                                  final deleted = await context.push<bool>(
                                    AppRouterName.teacherHomeworkDetails,
                                    extra: homework.id,
                                  );
                                  if (deleted == true) {
                                    cubit.fetchHomeworks();
                                  }
                                },
                                onDelete: () => cubit.deleteHomework(homework.id),
                              );
                            },
                          ),
              ),
            ),
          ),
          bottomNavigationBar: state.homeworks.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await context.push(AppRouterName.teacherCreateHomework);
                      cubit.fetchHomeworks();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: Text(
                      'اضافه واجب جديد',
                      style: AppStyles.font16Bold(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
