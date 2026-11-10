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
import '../../logic/teacher_subject_units_cubit.dart';
import '../../logic/teacher_subject_units_state.dart';
import '../components/subject_unit_card.dart';
import '../components/teacher_subjects_search_bar.dart';

class TeacherSubjectUnitsView extends StatelessWidget {
  final String subjectId;
  final String? gradeLevelId;
  final String initialSubjectName;

  const TeacherSubjectUnitsView({
    super.key,
    required this.subjectId,
    this.gradeLevelId,
    this.initialSubjectName = 'الرياضيات',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherSubjectUnitsCubit(
        getIt(),
        subjectId: subjectId,
        gradeLevelId: gradeLevelId,
        initialSubjectName: initialSubjectName,
      ),
      child: const _TeacherSubjectUnitsViewBody(),
    );
  }
}

class _TeacherSubjectUnitsViewBody extends StatefulWidget {
  const _TeacherSubjectUnitsViewBody();

  @override
  State<_TeacherSubjectUnitsViewBody> createState() =>
      _TeacherSubjectUnitsViewBodyState();
}

class _TeacherSubjectUnitsViewBodyState
    extends State<_TeacherSubjectUnitsViewBody> {
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
    final cubit = context.read<TeacherSubjectUnitsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherSubjectUnitsCubit, TeacherSubjectUnitsState>(
          builder: (context, state) {
            if (state is TeacherSubjectUnitsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadUnits(),
              );
            }

            final isLoading = state is TeacherSubjectUnitsLoadingState;
            final successState = state is TeacherSubjectUnitsSuccessState
                ? state
                : null;
            final units = successState?.filteredUnits ?? const [];
            final subjectName = successState?.subjectName ?? cubit.initialSubjectName;

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
                            subjectName,
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
                  child: TeacherSubjectsSearchBar(
                    controller: _searchController,
                    hintText: 'ابحث عن مادة ....',
                    onChanged: (val) => cubit.searchUnits(val),
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الوحدات التعليميه',
                        style: AppStyles.font16Bold(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '${units.length} وحدات',
                          style: AppStyles.font12Medium(context).copyWith(
                            fontWeight: AppFontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: RefreshIndicator(
                      onRefresh: () => cubit.loadUnits(isRefresh: true),
                      color: AppColors.primary,
                      child: units.isEmpty && !isLoading
                          ? ListView(
                              children: [
                                80.verticalSpace,
                                Center(
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    size: 64.sp,
                                    color: colorScheme.outline,
                                  ),
                                ),
                                16.verticalSpace,
                                Center(
                                  child: Text(
                                    'لا توجد وحدات بعد في هذه المادة',
                                    style: AppStyles.font14Medium(context).copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              itemCount: units.length,
                              separatorBuilder: (context, index) => 12.verticalSpace,
                              itemBuilder: (context, index) {
                                final unit = units[index];
                                return SubjectUnitCard(
                                  unit: unit,
                                  index: index,
                                  onTap: () {
                                    context.push(
                                      AppRouterName.teacherUnitDetails,
                                      extra: {
                                        'unitId': unit.id,
                                        'title': unit.title,
                                        'subjectName': subjectName,
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
                    text: 'اضافه وحده جديده',
                    onPressed: () async {
                      final created = await context.push<bool>(
                        AppRouterName.teacherAddUnit,
                        extra: {
                          'subjectId': cubit.subjectId,
                          'subjectName': subjectName,
                          'gradeLevelId': cubit.gradeLevelId,
                          'nextUnitNumber': units.length + 1,
                        },
                      );
                      if (created == true) {
                        cubit.loadUnits(isRefresh: true);
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
