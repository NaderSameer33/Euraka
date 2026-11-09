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
import '../../logic/teacher_groups_cubit.dart';
import '../../logic/teacher_groups_state.dart';
import '../components/teacher_group_card.dart';
import '../components/teacher_groups_search_bar.dart';

class TeacherGroupsView extends StatelessWidget {
  const TeacherGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TeacherGroupsCubit>(),
      child: const _TeacherGroupsViewBody(),
    );
  }
}

class _TeacherGroupsViewBody extends StatefulWidget {
  const _TeacherGroupsViewBody();

  @override
  State<_TeacherGroupsViewBody> createState() => _TeacherGroupsViewBodyState();
}

class _TeacherGroupsViewBodyState extends State<_TeacherGroupsViewBody> {
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
    final cubit = context.read<TeacherGroupsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherGroupsCubit, TeacherGroupsState>(
          builder: (context, state) {
            if (state is TeacherGroupsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadGroups(),
              );
            }

            final isLoading = state is TeacherGroupsLoadingState;
            final groups = state is TeacherGroupsSuccessState
                ? state.filteredGroups
                : TeacherGroupsCubit.dummyGroups();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                12.verticalSpace,
                Text(
                  'المجموعات',
                  style: AppStyles.font18Bold(context),
                  textAlign: TextAlign.center,
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TeacherGroupsSearchBar(
                    controller: _searchController,
                    onChanged: (val) => cubit.searchGroups(val),
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مجموعاتي',
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
                    onRefresh: () => cubit.loadGroups(isRefresh: true),
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
                      child: groups.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group_off_rounded,
                                    size: 56.sp,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    'لا توجد مجموعات حالية',
                                    style: AppStyles.font14Regular(context),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.h,
                                crossAxisSpacing: 12.w,
                                childAspectRatio: 0.63,
                              ),
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                final group = groups[index];
                                return TeacherGroupCard(
                                  group: group,
                                  teacherName: cubit.teacherName,
                                  onTap: () {
                                    context.push(
                                      AppRouterName.teacherGroupStudents,
                                      extra: {
                                        'groupId': group.id,
                                        'groupName': group.name,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: AppButton(
                    text: 'اضافه مجموعه',
                    height: 48.h,
                    borderRadius: 12.r,
                    textStyle: AppStyles.font16BoldWhite,
                    onPressed: () async {
                      final result = await context.push(AppRouterName.teacherAddGroup);
                      if (result == true && context.mounted) {
                        cubit.loadGroups(isRefresh: true);
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

