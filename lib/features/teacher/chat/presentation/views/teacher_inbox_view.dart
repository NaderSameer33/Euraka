import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../components/chat_time_formatter.dart';
import '../../data/models/teacher_conversation_model.dart';
import '../../logic/teacher_conversations_cubit.dart';
import '../../logic/teacher_conversations_state.dart';

class TeacherInboxView extends StatelessWidget {
  const TeacherInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherConversationsCubit>(
      create: (context) => getIt<TeacherConversationsCubit>()..fetchConversations(),
      child: const _TeacherInboxContent(),
    );
  }
}

class _TeacherInboxContent extends StatefulWidget {
  const _TeacherInboxContent();

  @override
  State<_TeacherInboxContent> createState() => _TeacherInboxContentState();
}

class _TeacherInboxContentState extends State<_TeacherInboxContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static List<TeacherConversationModel> get _dummyPlaceholders => List.generate(
        4,
        (i) => TeacherConversationModel(
          id: 'placeholder_$i',
          groupId: 'grp_$i',
          groupName: 'مجموعة الأحياء',
          subjectName: 'الأحياء',
          studentId: 'std_$i',
          studentName: i == 0
              ? 'أحمد محمد'
              : i == 1
                  ? 'فاطمة السيد'
                  : i == 2
                      ? 'محمد علي'
                      : 'سارة حسن',
          lastMessageContent: i == 0
              ? 'مش فاهم الدرس يا مستر'
              : i == 1
                  ? 'مش عارفه اطبق علي درس الرياضيات'
                  : i == 2
                      ? 'شكرا جدا يا مستر'
                      : 'المعادلات مش فاهمها يا مستر',
          lastMessageAt: DateTime.now().toIso8601String(),
          unreadCount: i == 0 ? 2 : (i == 2 ? 1 : 0),
          isOnline: i == 0 || i == 2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherConversationsCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onSurface,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          title: Text(
            'طلابي',
            style: AppStyles.font18Bold(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
                child: _buildSearchBar(context, cubit),
              ),
              Expanded(
                child: BlocBuilder<TeacherConversationsCubit, TeacherConversationsState>(
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
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                          itemCount: _dummyPlaceholders.length,
                          separatorBuilder: (context, index) => 12.verticalSpace,
                          itemBuilder: (context, index) => _buildConversationCard(
                            context: context,
                            conversation: _dummyPlaceholders[index],
                            onTap: () {},
                          ),
                        ),
                      );
                    }

                    final list = state.filteredConversations;

                    if (list.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () => cubit.fetchConversations(),
                        color: AppColors.primary,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 120.h),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.w,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 38.sp,
                                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'لا توجد نتائج بحث مطابقة'
                                        : 'لا توجد محادثات نشطة مع الطلاب حالياً',
                                    style: AppStyles.font14Medium(context).copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => cubit.fetchConversations(),
                      color: AppColors.primary,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                        itemCount: list.length,
                        separatorBuilder: (context, index) => 12.verticalSpace,
                        itemBuilder: (context, index) {
                          final conversation = list[index];
                          return _buildConversationCard(
                            context: context,
                            conversation: conversation,
                            onTap: () async {
                              await context.push(
                                AppRouterName.teacherChat,
                                extra: conversation,
                              );
                              if (context.mounted) {
                                cubit.fetchConversations();
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, TeacherConversationsCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: cubit.onSearchChanged,
        style: AppStyles.font14Regular(context),
        decoration: InputDecoration(
          hintText: 'ابحث عن طالب معين',
          hintStyle: AppStyles.font13Regular(context).copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          suffixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            size: 22.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildConversationCard({
    required BuildContext context,
    required TeacherConversationModel conversation,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = ChatTimeFormatter.formatTimestamp(conversation.lastMessageAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: ClipOval(
                    child: conversation.studentAvatarUrl != null &&
                            conversation.studentAvatarUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: conversation.studentAvatarUrl!,
                            fit: BoxFit.cover,
                            placeholder: (c, u) => Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: const Center(child: AppLoading()),
                            ),
                            errorWidget: (c, u, e) => Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.person_rounded,
                                size: 28.sp,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.person_rounded,
                              size: 28.sp,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.studentName,
                    style: AppStyles.font16Bold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    conversation.lastMessageContent != null &&
                            conversation.lastMessageContent!.isNotEmpty
                        ? conversation.lastMessageContent!
                        : (conversation.groupName.isNotEmpty
                            ? conversation.groupName
                            : 'بدء محادثة جديدة'),
                    style: AppStyles.font13Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: AppStyles.font12Regular(context).copyWith(
                    color: conversation.unreadCount > 0
                        ? AppColors.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                8.verticalSpace,
                if (conversation.unreadCount > 0)
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${conversation.unreadCount}',
                        style: AppStyles.font11SemiBold(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(height: 20.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
