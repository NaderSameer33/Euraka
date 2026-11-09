import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_weight.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../logic/group_students_cubit.dart';
import '../../logic/group_students_state.dart';
import '../components/group_student_card.dart';
import '../components/teacher_groups_search_bar.dart';

class TeacherGroupStudentsView extends StatelessWidget {
  final String groupId;
  final String groupName;

  const TeacherGroupStudentsView({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GroupStudentsCubit>(
        param1: (groupId: groupId, groupName: groupName),
      ),
      child: const _TeacherGroupStudentsViewBody(),
    );
  }
}

class _TeacherGroupStudentsViewBody extends StatefulWidget {
  const _TeacherGroupStudentsViewBody();

  @override
  State<_TeacherGroupStudentsViewBody> createState() => _TeacherGroupStudentsViewBodyState();
}

class _TeacherGroupStudentsViewBodyState extends State<_TeacherGroupStudentsViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<GroupStudentsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<GroupStudentsCubit, GroupStudentsState>(
          builder: (context, state) {
            if (state is GroupStudentsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadStudents(),
              );
            }

            final isLoading = state is GroupStudentsLoadingState;
            final students = state is GroupStudentsSuccessState
                ? state.filteredStudents
                : GroupStudentsCubit.dummyStudents();
            final title = state is GroupStudentsSuccessState
                ? state.groupName
                : cubit.initialGroupName;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 20.sp,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: AppStyles.font18Bold(context),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TeacherGroupsSearchBar(
                    controller: _searchController,
                    hintText: '...ابحث عن طالب',
                    onChanged: (val) => cubit.searchStudents(val),
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طلابي',
                        style: AppStyles.font16Bold(context).copyWith(
                          fontWeight: AppFontWeight.extraBold,
                        ),
                      ),
                      Text(
                        'عرض الكل',
                        style: AppStyles.font14MediumPrimary.copyWith(
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => cubit.loadStudents(isRefresh: true),
                    color: AppColors.primary,
                    child: Skeletonizer(
                      enabled: isLoading,
                      effect: ShimmerEffect(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        baseColor: colorScheme.surfaceContainerHighest,
                        highlightColor: colorScheme.surfaceContainer,
                        duration: const Duration(milliseconds: 1400),
                      ),
                      child: students.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 56.sp,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    'لا يوجد طلاب في هذه المجموعة حالياً',
                                    style: AppStyles.font14Regular(context),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                return GroupStudentCard(
                                  student: students[index],
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'اضافه طالب',
                          height: 48.h,
                          borderRadius: 12.r,
                          textStyle: AppStyles.font16BoldWhite.copyWith(
                            fontSize: 15.sp,
                          ),
                          onPressed: () async {
                            final result = await context.push(
                              AppRouterName.teacherAddStudent,
                              extra: {
                                'groupId': cubit.groupId,
                                'groupName': title,
                              },
                            );
                            if (result == true && context.mounted) {
                              cubit.loadStudents(isRefresh: true);
                            }
                          },
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'اضافه كود دعوه',
                                style: AppStyles.font16BoldPrimary.copyWith(
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
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
}

