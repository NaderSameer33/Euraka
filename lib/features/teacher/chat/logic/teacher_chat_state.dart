import 'package:equatable/equatable.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/teacher_conversation_model.dart';

class TeacherChatState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final TeacherConversationModel? conversation;
  final List<ChatMessageModel> messages;
  final bool isOtherUserTyping;
  final bool isOnline;
  final bool hasReachedEnd;
  final String? errorMessage;

  const TeacherChatState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.conversation,
    this.messages = const [],
    this.isOtherUserTyping = false,
    this.isOnline = true,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  TeacherChatState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    TeacherConversationModel? conversation,
    List<ChatMessageModel>? messages,
    bool? isOtherUserTyping,
    bool? isOnline,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return TeacherChatState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      isOnline: isOnline ?? this.isOnline,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        conversation,
        messages,
        isOtherUserTyping,
        isOnline,
        hasReachedEnd,
        errorMessage,
      ];
}

