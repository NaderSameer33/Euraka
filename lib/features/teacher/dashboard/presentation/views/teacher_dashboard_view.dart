import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/teacher_dashboard_response_model.dart';
import '../../logic/teacher_dashboard_cubit.dart';
import '../../logic/teacher_dashboard_state.dart';
import '../components/teacher_action_buttons.dart';
import '../components/teacher_active_exams_section.dart';
import '../components/teacher_dashboard_header.dart';
import '../components/teacher_kpi_cards_grid.dart';
import '../components/teacher_recent_groups_section.dart';

class TeacherDashboardView extends StatelessWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TeacherDashboardCubit>(),
      child: const _TeacherDashboardViewBody(),
    );
  }
}

class _TeacherDashboardViewBody extends StatelessWidget {
  const _TeacherDashboardViewBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.read<TeacherDashboardCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherDashboardCubit, TeacherDashboardState>(
          builder: (context, state) {
            if (state is TeacherDashboardErrorState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      16.verticalSpace,
                      Text(
                        state.message,
                        style: AppStyles.font14Regular(context),
                        textAlign: TextAlign.center,
                      ),
                      16.verticalSpace,
                      ElevatedButton(
                        onPressed: () => cubit.loadDashboard(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            fontFamily: AppStyles.fontFamily,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final isLoading = state is TeacherDashboardLoadingState;
            final TeacherDashboardData data = state is TeacherDashboardSuccessState
                ? state.data
                : TeacherDashboardCubit.dummyData();
            final teacherName = state is TeacherDashboardSuccessState
                ? state.teacherName
                : cubit.teacherName;

            return RefreshIndicator(
              onRefresh: () => cubit.loadDashboard(isRefresh: true),
              color: AppColors.primary,
              child: Skeletonizer(
                enabled: isLoading,
                effect: ShimmerEffect(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  baseColor: isDark ? const Color(0xFF1E242C) : const Color(0xFFE5E7EB),
                  highlightColor: isDark ? const Color(0xFF2A323D) : const Color(0xFFF3F4F6),
                  duration: const Duration(milliseconds: 1400),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TeacherDashboardHeader(
                        teacherName: teacherName,
                      ),
                      20.verticalSpace,
                      TeacherKpiCardsGrid(kpis: data.kpis),
                      18.verticalSpace,
                      const TeacherActionButtons(),
                      20.verticalSpace,
                      TeacherRecentGroupsSection(groups: data.recentGroups),
                      12.verticalSpace,
                      TeacherActiveExamsSection(exams: data.activeExams),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

