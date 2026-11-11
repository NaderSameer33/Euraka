import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
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
  TaskCategoryType _selectedCategory = TaskCategoryType.all;
  final List<TeacherTaskCardModel> _allTasks = TeacherTaskCardModel.getTasks();

  List<TeacherTaskCardModel> get _filteredTasks {
    if (_selectedCategory == TaskCategoryType.all) {
      return _allTasks;
    }
    return _allTasks.where((task) => task.category == _selectedCategory).toList();
  }

  void _onActionTap(TeacherTaskCardModel task) {
    HelperMethod.showInfoToast(
      context: context,
      message: 'سيتم فتح ${task.buttonText} قريباً',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
              },
            ),
            Expanded(
              child: ListView.separated(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

