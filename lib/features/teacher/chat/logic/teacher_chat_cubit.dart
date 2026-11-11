import 'dart:async';
import '../../../../../core/base/safe_cubit.dart';
import '../../../../../core/services/socket_service.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/teacher_conversation_model.dart';
import '../data/repos/teacher_chat_repo.dart';
import 'teacher_chat_state.dart';

class TeacherChatCubit extends SafeCubit<TeacherChatState> {
  final String conversationId;
  final TeacherChatRepo _chatRepo;
  final SocketService _socketService;

  StreamSubscription? _msgSub;
  StreamSubscription? _readSub;
  StreamSubscription? _typingSub;
  Timer? _typingTimer;
  bool _isTypingSent = false;

  TeacherChatCubit({
    required this.conversationId,
    TeacherConversationModel? initialConversation,
    required this._chatRepo,
    required this._socketService,
  }) : super(TeacherChatState(conversation: initialConversation)) {
    _initChat();
  }

  void _initChat() {
    _socketService.initSocket();

    if (state.conversation == null) {
      _loadConversationDetails();
    } else {
      _socketService.startConversation(
        groupId: state.conversation!.groupId,
        studentId: state.conversation!.studentId,
      );
    }

    _loadInitialMessages();
    _setupSocketListeners();
    _markConversationAsRead();
  }

  void _setupSocketListeners() {
    _msgSub = _socketService.newMessageStream.listen((data) {
      final convId = data['conversationId'] as String?;
      if (convId == conversationId) {
        final newMsg = ChatMessageModel.fromJson(data);
        _handleIncomingMessage(newMsg);
      }
    });

    _readSub = _socketService.messagesReadStream.listen((data) {
      final convId = data['conversationId'] as String?;
      if (convId == conversationId) {
        _handleMessagesRead();
      }
    });

    _typingSub = _socketService.typingStream.listen((data) {
      final convId = data['conversationId'] as String?;
      if (convId == conversationId) {
        final isTyping = data['isTyping'] as bool? ?? false;
        emit(state.copyWith(isOtherUserTyping: isTyping));
      }
    });
  }

  Future<void> _loadConversationDetails() async {
    final result = await _chatRepo.getConversationDetails(conversationId);
    result.fold(
      (failure) {},
      (details) {
        emit(state.copyWith(conversation: details));
        _socketService.startConversation(
          groupId: details.groupId,
          studentId: details.studentId,
        );
      },
    );
  }

  Future<void> _loadInitialMessages() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _chatRepo.getMessageHistory(conversationId, page: 1, limit: 30);
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (list) {
        final sorted = List<ChatMessageModel>.from(list);
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(state.copyWith(
          isLoading: false,
          messages: sorted,
          hasReachedEnd: list.length < 30,
        ));
      },
    );
  }

  Future<void> loadOlderMessages() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.messages.isEmpty) return;

    final oldestId = state.messages.last.id;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _chatRepo.getOlderMessages(
      conversationId,
      beforeMessageId: oldestId,
      limit: 30,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (older) {
        if (older.isEmpty) {
          emit(state.copyWith(
            isLoadingMore: false,
            hasReachedEnd: true,
          ));
          return;
        }

        final sortedOlder = List<ChatMessageModel>.from(older);
        sortedOlder.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final combined = [...state.messages, ...sortedOlder];
        emit(state.copyWith(
          isLoadingMore: false,
          messages: combined,
          hasReachedEnd: older.length < 30,
        ));
      },
    );
  }

  void _handleIncomingMessage(ChatMessageModel incoming) {
    final existsIndex = state.messages.indexWhere((m) {
      if (incoming.clientMessageId != null && m.clientMessageId == incoming.clientMessageId) {
        return true;
      }
      return m.id == incoming.id;
    });

    List<ChatMessageModel> updatedList;
    if (existsIndex != -1) {
      updatedList = List<ChatMessageModel>.from(state.messages);
      updatedList[existsIndex] = incoming.copyWith(isSending: false, hasFailed: false);
    } else {
      updatedList = [incoming, ...state.messages];
      updatedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    emit(state.copyWith(messages: updatedList));
    _markConversationAsRead();
  }

  void _handleMessagesRead() {
    final updated = state.messages.map((m) {
      if (m.isMine && !m.isRead) {
        return m.copyWith(isRead: true);
      }
      return m;
    }).toList();
    emit(state.copyWith(messages: updated));
  }

  Future<void> _markConversationAsRead() async {
    _socketService.markRead(conversationId: conversationId);
    await _chatRepo.markConversationAsRead(conversationId);
  }

  void onTextChanged(String text) {
    if (text.trim().isNotEmpty && !_isTypingSent) {
      _isTypingSent = true;
      _socketService.sendTyping(conversationId: conversationId, isTyping: true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 2000), () {
      if (_isTypingSent) {
        _isTypingSent = false;
        _socketService.sendTyping(conversationId: conversationId, isTyping: false);
      }
    });
  }

  void sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final clientMsgId = '${DateTime.now().millisecondsSinceEpoch}_${state.messages.length}';
    final localMsg = ChatMessageModel(
      id: clientMsgId,
      conversationId: conversationId,
      senderId: '',
      content: trimmed,
      createdAt: DateTime.now().toIso8601String(),
      isMine: true,
      isSending: true,
      clientMessageId: clientMsgId,
    );

    final updated = [localMsg, ...state.messages];
    emit(state.copyWith(messages: updated));

    _socketService.sendMessage(
      conversationId: conversationId,
      content: trimmed,
      clientMessageId: clientMsgId,
      onAck: (ack) {
        if (ack is Map && ack['success'] == true) {
          final serverMsgData = ack['message'] is Map ? ack['message'] as Map<String, dynamic> : null;
          final updatedList = state.messages.map((m) {
            if (m.clientMessageId == clientMsgId) {
              return m.copyWith(
                id: serverMsgData?['id'] as String? ?? m.id,
                isSending: false,
                hasFailed: false,
              );
            }
            return m;
          }).toList();
          emit(state.copyWith(messages: updatedList));
        } else {
          final updatedList = state.messages.map((m) {
            if (m.clientMessageId == clientMsgId) {
              return m.copyWith(
                isSending: false,
                hasFailed: true,
              );
            }
            return m;
          }).toList();
          emit(state.copyWith(messages: updatedList));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    if (_isTypingSent) {
      _socketService.sendTyping(conversationId: conversationId, isTyping: false);
    }
    _msgSub?.cancel();
    _readSub?.cancel();
    _typingSub?.cancel();
    return super.close();
  }
}
