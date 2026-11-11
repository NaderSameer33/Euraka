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
import '../../../homework/data/models/teacher_homework_model.dart';
import '../../../homework/logic/teacher_homework_list_cubit.dart';
import '../../../homework/logic/teacher_homework_list_state.dart';
import '../../../homework/presentation/components/teacher_homework_card.dart';
import '../../data/models/teacher_task_card_model.dart';
import '../components/task_card.dart';
import '../components/tasks_app_bar.dart';
import '../components/tasks_tab_bar.dart';

class TeacherTasksView extends StatefulWidget {
  const TeacherTasksView({super.key});

  @override
  State<TeacherTasksView> createState() => _TeacherTasksViewState();
}

class _TeacherTasksViewState extends State<TeacherTasksView> {
  late final TeacherHomeworkListCubit _homeworkCubit;
  TaskCategoryType _selectedCategory = TaskCategoryType.all;
  final List<TeacherTaskCardModel> _allTasks = TeacherTaskCardModel.getTasks();

  @override
  void initState() {
    super.initState();
    _homeworkCubit = getIt<TeacherHomeworkListCubit>()..fetchHomeworks();
  }

  @override
  void dispose() {
    _homeworkCubit.close();
    super.dispose();
  }

  List<TeacherTaskCardModel> get _filteredTasks {
    if (_selectedCategory == TaskCategoryType.all) {
      return _allTasks;
    }
    return _allTasks.where((task) => task.category == _selectedCategory).toList();
  }

  void _onActionTap(TeacherTaskCardModel task) {
    if (task.id == 'homework' || task.category == TaskCategoryType.homework) {
      context.push(AppRouterName.teacherCreateHomework);
      return;
    }
    HelperMethod.showInfoToast(
      context: context,
      message: 'سيتم فتح ${task.buttonText} قريباً',
    );
  }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _homeworkCubit,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const TasksAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              TasksTabBar(
                selectedCategory: _selectedCategory,
                onCategorySelected: (cat) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                  if (cat == TaskCategoryType.homework) {
                    _homeworkCubit.fetchHomeworks();
                  }
                },
              ),
              Expanded(
                child: _selectedCategory == TaskCategoryType.homework
                    ? _buildHomeworkSection(context)
                    : _buildDefaultTasksSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultTasksSection(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: _filteredTasks.length,
      separatorBuilder: (context, index) => 14.verticalSpace,
      itemBuilder: (context, index) {
        final task = _filteredTasks[index];
        return TaskCard(
          task: task,
          onActionTap: () => _onActionTap(task),
        );
      },
    );
  }

  Widget _buildHomeworkSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        if (state.isLoading) {
          return Skeletonizer(
            enabled: true,
            effect: ShimmerEffect(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              baseColor: colorScheme.surfaceContainerHighest,
              highlightColor: colorScheme.surfaceContainer,
              duration: const Duration(milliseconds: 1400),
            ),
            child: ListView.separated(
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
            ),
          );
        }

        if (state.homeworks.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'قم بإضافة واجب جديد لتظهر هنا ويتمكن الطلاب من حله',
                    style: AppStyles.font13Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context.push(AppRouterName.teacherCreateHomework);
                      _homeworkCubit.fetchHomeworks();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
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
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _homeworkCubit.fetchHomeworks(),
          color: AppColors.primary,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الواجبات المنشورة (${state.homeworks.length})',
                      style: AppStyles.font14Bold(context),
                    ),
                    InkWell(
                      onTap: () async {
                        await context.push(AppRouterName.teacherCreateHomework);
                        _homeworkCubit.fetchHomeworks();
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            6.horizontalSpace,
                            Text(
                              'واجب جديد',
                              style: AppStyles.font12Medium(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                          _homeworkCubit.fetchHomeworks();
                        }
                      },
                      onDelete: () => _homeworkCubit.deleteHomework(homework.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
