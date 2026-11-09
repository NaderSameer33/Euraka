import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_error_widget.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../data/models/teacher_student_details_model.dart';
import '../../logic/teacher_student_details_cubit.dart';
import '../../logic/teacher_student_details_state.dart';

class TeacherStudentDetailsView extends StatelessWidget {
  final String studentId;
  final String? groupId;
  final String? groupName;
  final bool? isPaid;
  final String? paymentStatus;

  const TeacherStudentDetailsView({
    super.key,
    required this.studentId,
    this.groupId,
    this.groupName,
    this.isPaid,
    this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherStudentDetailsCubit>(
      create: (_) => getIt<TeacherStudentDetailsCubit>(
        param1: (
          studentId: studentId,
          groupName: groupName,
          isPaid: isPaid,
          paymentStatus: paymentStatus,
        ),
      ),
      child: const _TeacherStudentDetailsContent(),
    );
  }
}

class _TeacherStudentDetailsContent extends StatelessWidget {
  const _TeacherStudentDetailsContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherStudentDetailsCubit>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تفاصيل الطالب',
          style: AppStyles.font18Bold(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w),
            child: InkWell(
              onTap: () => context.pop(true),
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TeacherStudentDetailsCubit, TeacherStudentDetailsState>(
        builder: (context, state) {
          if (state is TeacherStudentDetailsError) {
            return Center(
              child: AppErrorWidget(
                message: state.message,
                onRetry: () => cubit.fetchStudentDetails(),
              ),
            );
          }

          final isLoading = state is TeacherStudentDetailsLoading;
          final data = state is TeacherStudentDetailsSuccess
              ? state.data
              : (cubit.currentData ?? TeacherStudentDetailsData.dummy());

          final student = data.studentInfo;
          final enrolledGroup = data.enrolledGroups.isNotEmpty
              ? data.enrolledGroups.first
              : null;
          final groupTitle = enrolledGroup?.groupName ?? cubit.initialGroupName ?? 'المجموعة';
          final isPaid = data.isPaid;
          final paymentLabel = data.paymentStatus;

          return RefreshIndicator(
            onRefresh: () => cubit.fetchStudentDetails(),
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 86.w,
                                  height: 86.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.outline.withValues(alpha: 0.15),
                                      width: 2.w,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: student.avatarUrl != null && student.avatarUrl!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: student.avatarUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (c, u) => Container(
                                              color: colorScheme.surfaceContainerHighest,
                                              child: const Center(child: AppLoading()),
                                            ),
                                            errorWidget: (c, u, e) => Container(
                                              color: colorScheme.surfaceContainerHighest,
                                              child: Icon(
                                                Icons.person_rounded,
                                                size: 44.sp,
                                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: colorScheme.surfaceContainerHighest,
                                            child: Icon(
                                              Icons.person_rounded,
                                              size: 44.sp,
                                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                          ),
                                  ),
                                ),
                                PositionedDirectional(
                                  bottom: 0,
                                  start: 0,
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.surface,
                                        width: 2.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Center(
                            child: Text(
                              student.fullName,
                              style: AppStyles.font18Bold(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          20.verticalSpace,
                          _buildStudentInfoCard(
                            context: context,
                            groupTitle: groupTitle,
                            studentPhone: student.phone.isNotEmpty ? student.phone : 'غير متوفر',
                            parentPhone: student.parentPhone.isNotEmpty ? student.parentPhone : 'غير متوفر',
                            levelText: student.gradeLevelName.isNotEmpty
                                ? student.gradeLevelName
                                : 'متوسط',
                            isPaid: isPaid,
                            paymentLabel: paymentLabel,
                          ),
                          16.verticalSpace,
                          _buildQuickActionsBar(
                            context: context,
                            data: data,
                            groupId: enrolledGroup?.groupId,
                            groupName: groupTitle,
                          ),
                          16.verticalSpace,
                          _buildTeacherNotesCard(context: context),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: AppButton(
                        text: 'ارسال رساله',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentInfoCard({
    required BuildContext context,
    required String groupTitle,
    required String studentPhone,
    required String parentPhone,
    required String levelText,
    required bool isPaid,
    required String paymentLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          _buildInfoRow(
            context: context,
            icon: Icons.people_outline_rounded,
            title: 'المجموعة',
            valueWidget: Text(
              groupTitle,
              style: AppStyles.font13Medium(context),
            ),
          ),
          Divider(height: 20.h, color: colorScheme.outline.withValues(alpha: 0.1)),
          _buildInfoRow(
            context: context,
            icon: Icons.phone_outlined,
            title: 'رقم الطالب',
            valueWidget: Text(
              studentPhone,
              style: AppStyles.font13Medium(context),
            ),
          ),
          Divider(height: 20.h, color: colorScheme.outline.withValues(alpha: 0.1)),
          _buildInfoRow(
            context: context,
            icon: Icons.phone_outlined,
            title: 'رقم ولي الأمر',
            valueWidget: Text(
              parentPhone,
              style: AppStyles.font13Medium(context),
            ),
          ),
          Divider(height: 20.h, color: colorScheme.outline.withValues(alpha: 0.1)),
          _buildInfoRow(
            context: context,
            icon: Icons.bar_chart_rounded,
            title: 'المستوى',
            valueWidget: Text(
              levelText,
              style: AppStyles.font13Medium(context),
            ),
          ),
          Divider(height: 20.h, color: colorScheme.outline.withValues(alpha: 0.1)),
          _buildInfoRow(
            context: context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'حالة الدفع',
            valueWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isPaid
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : const Color(0xFFEF4444).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPaid ? AppColors.primary : const Color(0xFFEF4444),
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    paymentLabel.isNotEmpty ? paymentLabel : (isPaid ? 'مدفوع' : 'غير مدفوع'),
                    style: AppStyles.font12Medium(context).copyWith(
                      color: isPaid ? AppColors.primary : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget valueWidget,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp,
          ),
        ),
        10.horizontalSpace,
        Text(
          title,
          style: AppStyles.font13Regular(context).copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        valueWidget,
      ],
    );
  }

  Widget _buildQuickActionsBar({
    required BuildContext context,
    required TeacherStudentDetailsData data,
    String? groupId,
    String? groupName,
  }) {
    final cubit = context.read<TeacherStudentDetailsCubit>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionItem(
            context: context,
            icon: Icons.receipt_long_outlined,
            label: 'فواتيري',
            onTap: () {},
          ),
          _buildQuickActionItem(
            context: context,
            icon: Icons.edit_note_rounded,
            label: 'تعديل بيانات',
            onTap: () async {
              final result = await context.push(
                AppRouterName.teacherEditStudent,
                extra: {
                  'studentId': cubit.studentId,
                  'initialData': data,
                  'groupId': groupId,
                  'groupName': groupName,
                },
              );
              if (result != null && context.mounted) {
                if (result is Map<String, dynamic>) {
                  cubit.updateStudentInfo(
                    fullName: result['fullName'] as String?,
                    parentPhone: result['parentPhone'] as String?,
                    gradeLevelName: result['gradeLevelName'] as String?,
                    isPaid: result['isPaid'] as bool?,
                    paymentStatus: result['paymentStatus'] as String?,
                  );
                } else {
                  cubit.fetchStudentDetails();
                }
              }
            },
          ),
          _buildQuickActionItem(
            context: context,
            icon: Icons.swap_horiz_rounded,
            label: 'نقل المجموعة',
            onTap: () {},
          ),
          _buildQuickActionItem(
            context: context,
            icon: Icons.credit_card_outlined,
            label: 'تسجيل دفعة',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 22.sp,
            ),
            6.verticalSpace,
            Text(
              label,
              style: AppStyles.font11SemiBold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherNotesCard({required BuildContext context}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ),
              10.horizontalSpace,
              Text(
                'ملاحظات المدرس',
                style: AppStyles.font14Bold(context),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'طالب جيد لكن يتأخر في الواجبات',
            style: AppStyles.font12Regular(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
