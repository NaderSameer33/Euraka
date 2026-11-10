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
import '../../logic/teacher_subjects_cubit.dart';
import '../../logic/teacher_subjects_state.dart';
import '../components/teacher_subject_card.dart';
import '../components/teacher_subjects_search_bar.dart';

class TeacherSubjectsView extends StatelessWidget {
  const TeacherSubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TeacherSubjectsCubit>(),
      child: const _TeacherSubjectsViewBody(),
    );
  }
}

class _TeacherSubjectsViewBody extends StatefulWidget {
  const _TeacherSubjectsViewBody();

  @override
  State<_TeacherSubjectsViewBody> createState() => _TeacherSubjectsViewBodyState();
}

class _TeacherSubjectsViewBodyState extends State<_TeacherSubjectsViewBody> {
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
    final cubit = context.read<TeacherSubjectsCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherSubjectsCubit, TeacherSubjectsState>(
          builder: (context, state) {
            if (state is TeacherSubjectsErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadSubjects(),
              );
            }

            final isLoading = state is TeacherSubjectsLoadingState;
            final subjects = state is TeacherSubjectsSuccessState
                ? state.filteredSubjects
                : TeacherSubjectsCubit.dummySubjects();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                12.verticalSpace,
                Text(
                  'اداره المحتوي',
                  style: AppStyles.font18Bold(context),
                  textAlign: TextAlign.center,
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TeacherSubjectsSearchBar(
                    controller: _searchController,
                    onChanged: (val) => cubit.searchSubjects(val),
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المواد الدراسيه',
                        style: AppStyles.font16Bold(context).copyWith(
                          fontWeight: AppFontWeight.extraBold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${subjects.length} مواد',
                          style: AppStyles.font12MediumPrimary.copyWith(
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => cubit.loadSubjects(isRefresh: true),
                    color: colorScheme.primary,
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: subjects.isEmpty && !isLoading
                          ? ListView(
                              children: [
                                SizedBox(height: 80.h),
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 64.sp,
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                ),
                                16.verticalSpace,
                                Text(
                                  'لا توجد مواد دراسية حالياً',
                                  style: AppStyles.font16Medium(context).copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 14.h,
                                childAspectRatio: 0.64,
                              ),
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                final subject = subjects[index];
                                return TeacherSubjectCard(
                                  subject: subject,
                                  teacherName: cubit.teacherName,
                                  onTap: () {
                                    context.push(
                                      AppRouterName.teacherSubjectUnits,
                                      extra: {
                                        'subjectId': subject.id,
                                        'subjectName': subject.displayName,
                                        'gradeLevelId': subject.gradeLevelId,
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
                    text: 'اضافه ماده جديده',
                    onPressed: () async {
                      final result = await context.push<bool>(
                        AppRouterName.teacherAddSubject,
                      );
                      if (result == true && context.mounted) {
                        cubit.loadSubjects(isRefresh: true);
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
