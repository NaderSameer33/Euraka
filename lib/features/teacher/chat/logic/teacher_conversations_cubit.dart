import 'dart:async';
import '../../../../../core/base/safe_cubit.dart';
import '../../../../../core/services/socket_service.dart';
import '../data/models/teacher_conversation_model.dart';
import '../data/repos/teacher_chat_repo.dart';
import 'teacher_conversations_state.dart';

class TeacherConversationsCubit extends SafeCubit<TeacherConversationsState> {
  final TeacherChatRepo _chatRepo;
  final SocketService _socketService;
  StreamSubscription? _msgSub;
  StreamSubscription? _convUpdatedSub;

  TeacherConversationsCubit(this._chatRepo, this._socketService)
      : super(const TeacherConversationsState()) {
    _initSocketAndListeners();
  }

  void _initSocketAndListeners() {
    _socketService.initSocket();

    _msgSub = _socketService.newMessageStream.listen((data) {
      _handleIncomingMessage(data);
    });

    _convUpdatedSub = _socketService.conversationUpdatedStream.listen((data) {
      _handleConversationUpdated(data);
    });
  }

  Future<void> fetchConversations() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _chatRepo.getTeacherConversations();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (list) {
        emit(state.copyWith(
          isLoading: false,
          conversations: list,
          filteredConversations: _filterList(list, state.searchQuery),
          errorMessage: null,
        ));
      },
    );
  }

  void onSearchChanged(String query) {
    final filtered = _filterList(state.conversations, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredConversations: filtered,
    ));
  }

  List<TeacherConversationModel> _filterList(
    List<TeacherConversationModel> list,
    String query,
  ) {
    if (query.trim().isEmpty) return list;
    final lower = query.trim().toLowerCase();
    return list.where((item) {
      final nameMatches = item.studentName.toLowerCase().contains(lower);
      final groupMatches = item.groupName.toLowerCase().contains(lower);
      return nameMatches || groupMatches;
    }).toList();
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    final conversationId = data['conversationId'] as String?;
    final content = data['content'] as String?;
    final createdAt = data['createdAt'] as String?;
    final isMine = data['isMine'] as bool? ?? false;

    if (conversationId == null) return;

    final updated = state.conversations.map((conv) {
      if (conv.id == conversationId) {
        return conv.copyWith(
          lastMessageContent: content ?? conv.lastMessageContent,
          lastMessageAt: createdAt ?? conv.lastMessageAt,
          unreadCount: isMine ? conv.unreadCount : conv.unreadCount + 1,
        );
      }
      return conv;
    }).toList();

    emit(state.copyWith(
      conversations: updated,
      filteredConversations: _filterList(updated, state.searchQuery),
    ));
  }

  void _handleConversationUpdated(Map<String, dynamic> data) {
    final conversationId = data['id'] as String? ?? data['conversationId'] as String?;
    if (conversationId == null) return;

    final unread = (data['unreadCount'] as num?)?.toInt();
    final lastMsg = data['lastMessage'] is Map
        ? (data['lastMessage']['content'] as String?)
        : data['lastMessage'] as String?;
    final lastMsgAt = data['lastMessage'] is Map
        ? (data['lastMessage']['createdAt'] as String?)
        : data['lastMessageAt'] as String?;

    final updated = state.conversations.map((conv) {
      if (conv.id == conversationId) {
        return conv.copyWith(
          unreadCount: unread ?? conv.unreadCount,
          lastMessageContent: lastMsg ?? conv.lastMessageContent,
          lastMessageAt: lastMsgAt ?? conv.lastMessageAt,
        );
      }
      return conv;
    }).toList();

    emit(state.copyWith(
      conversations: updated,
      filteredConversations: _filterList(updated, state.searchQuery),
    ));
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _convUpdatedSub?.cancel();
    return super.close();
  }
}
