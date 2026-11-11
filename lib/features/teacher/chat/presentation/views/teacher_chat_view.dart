import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../components/chat_time_formatter.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/teacher_conversation_model.dart';
import '../../data/repos/teacher_chat_repo.dart';
import '../../../../../core/services/socket_service.dart';
import '../../logic/teacher_chat_cubit.dart';
import '../../logic/teacher_chat_state.dart';

class TeacherChatView extends StatelessWidget {
  final String conversationId;
  final TeacherConversationModel? conversation;

  const TeacherChatView({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherChatCubit>(
      create: (context) => TeacherChatCubit(
        conversationId: conversationId,
        initialConversation: conversation,
        chatRepo: getIt<TeacherChatRepo>(),
        socketService: getIt<SocketService>(),
      ),
      child: const _TeacherChatContent(),
    );
  }
}

class _TeacherChatContent extends StatefulWidget {
  const _TeacherChatContent();

  @override
  State<_TeacherChatContent> createState() => _TeacherChatContentState();
}

class _TeacherChatContentState extends State<_TeacherChatContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      context.read<TeacherChatCubit>().loadOlderMessages();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    context.read<TeacherChatCubit>().sendMessage(text);
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrollController.position.pixels > 0) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  static List<ChatMessageModel> get _placeholderMessages => [
        ChatMessageModel(
          id: 'p3',
          conversationId: 'p_conv',
          senderId: 'teacher',
          content: 'حاول تقرأه تاني كويس وهتفهمه',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          isMine: false,
        ),
        ChatMessageModel(
          id: 'p2',
          conversationId: 'p_conv',
          senderId: 'student',
          content: 'أنا مش فاهم السؤال الثاني يا دكتور',
          createdAt: DateTime.now().subtract(const Duration(minutes: 8)).toIso8601String(),
          isMine: true,
          isRead: true,
        ),
        ChatMessageModel(
          id: 'p1',
          conversationId: 'p_conv',
          senderId: 'teacher',
          content: 'مرحباً أحمد، كيف يمكنني مساعدتك اليوم؟',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          isMine: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<TeacherChatCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: false,
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
          title: BlocBuilder<TeacherChatCubit, TeacherChatState>(
            buildWhen: (prev, curr) =>
                prev.conversation != curr.conversation ||
                prev.isOtherUserTyping != curr.isOtherUserTyping ||
                prev.isOnline != curr.isOnline,
            builder: (context, state) {
              final studentName = state.conversation?.studentName ?? 'المحادثة';
              final avatarUrl = state.conversation?.studentAvatarUrl;
              final isOnline = state.conversation?.isOnline ?? true;
              final isTyping = state.isOtherUserTyping;

              return Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.15),
                          ),
                        ),
                        child: ClipOval(
                          child: avatarUrl != null && avatarUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: avatarUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (c, u) => Container(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: const Center(child: AppLoading()),
                                  ),
                                  errorWidget: (c, u, e) => Container(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 24.sp,
                                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 24.sp,
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                        ),
                      ),
                      if (isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        studentName,
                        style: AppStyles.font16Bold(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      2.verticalSpace,
                      Text(
                        isTyping
                            ? 'يكتب الآن...'
                            : (isOnline ? 'متصل الآن' : 'غير متصل'),
                        style: AppStyles.font12Regular(context).copyWith(
                          color: isTyping || isOnline
                              ? AppColors.primary
                              : colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<TeacherChatCubit, TeacherChatState>(
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
                          itemCount: _placeholderMessages.length,
                          separatorBuilder: (context, index) => 12.verticalSpace,
                          itemBuilder: (context, index) => _buildMessageItem(
                            context: context,
                            message: _placeholderMessages[index],
                          ),
                        ),
                      );
                    }

                    final messages = state.messages;

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_rounded,
                                size: 34.sp,
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            14.verticalSpace,
                            Text(
                              'لا توجد رسائل سابقة',
                              style: AppStyles.font14Medium(context).copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              'ابدأ المحادثة الآن واكتب رسالتك للطالب',
                              style: AppStyles.font12Regular(context).copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      itemCount: messages.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isLoadingMore && index == messages.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: const Center(child: AppLoading()),
                          );
                        }
                        final message = messages[index];
                        return _buildMessageItem(
                          context: context,
                          message: message,
                        );
                      },
                    );
                  },
                ),
              ),
              _buildInputBar(context, cubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required BuildContext context,
    required ChatMessageModel message,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = ChatTimeFormatter.formatMessageTime(message.createdAt);
    final isMine = message.isMine;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Align(
        alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 0.75.sw,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMine
                    ? AppColors.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: isMine ? Radius.circular(4.r) : Radius.circular(16.r),
                  bottomRight: isMine ? Radius.circular(16.r) : Radius.circular(4.r),
                ),
              ),
              child: Text(
                message.content,
                style: AppStyles.font14Regular(context).copyWith(
                  color: isMine ? Colors.white : colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
            4.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                  if (isMine) ...[
                    6.horizontalSpace,
                    if (message.isSending)
                      Icon(
                        Icons.access_time_rounded,
                        size: 13.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      )
                    else if (message.hasFailed)
                      Icon(
                        Icons.error_outline_rounded,
                        size: 13.sp,
                        color: Colors.redAccent,
                      )
                    else
                      Icon(
                        message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                        size: 15.sp,
                        color: message.isRead ? AppColors.primary : colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, TeacherChatCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: TextField(
                controller: _messageController,
                onChanged: cubit.onTextChanged,
                style: AppStyles.font14Regular(context),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintStyle: AppStyles.font13Regular(context).copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          10.horizontalSpace,
          InkWell(
            onTap: _sendMessage,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Center(
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
