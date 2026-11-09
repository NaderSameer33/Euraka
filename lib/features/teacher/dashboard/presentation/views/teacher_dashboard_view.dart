import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_error_widget.dart';
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
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherDashboardCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<TeacherDashboardCubit, TeacherDashboardState>(
          builder: (context, state) {
            if (state is TeacherDashboardErrorState) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.loadDashboard(),
              );
            }

            final isLoading = state is TeacherDashboardLoadingState;
            final TeacherDashboardData data = state is TeacherDashboardSuccessState
                ? state.data
                : TeacherDashboardCubit.dummyData();
            final teacherName = state is TeacherDashboardSuccessState
                ? state.teacherName
                : cubit.teacherName;
            final avatarUrl = state is TeacherDashboardSuccessState
                ? state.avatarUrl
                : cubit.avatarUrl;

            return RefreshIndicator(
              onRefresh: () => cubit.loadDashboard(isRefresh: true),
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TeacherDashboardHeader(
                        teacherName: teacherName,
                        avatarUrl: avatarUrl,
                      ),
                      20.verticalSpace,
                      TeacherKpiCardsGrid(kpis: data.kpis),
                      18.verticalSpace,
                      TeacherActionButtons(
                        onAddGroupPressed: () async {
                          final res = await context.push(AppRouterName.teacherAddGroup);
                          if (res == true && context.mounted) {
                            cubit.loadDashboard(isRefresh: true);
                          }
                        },
                      ),
                      20.verticalSpace,
                      TeacherRecentGroupsSection(
                        groups: data.recentGroups,
                        onViewAllPressed: () => context.go(AppRouterName.teacherGroups),
                      ),
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
