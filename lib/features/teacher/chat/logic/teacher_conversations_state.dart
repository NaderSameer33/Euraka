import 'package:equatable/equatable.dart';
import '../data/models/teacher_conversation_model.dart';

class TeacherConversationsState extends Equatable {
  final bool isLoading;
  final List<TeacherConversationModel> conversations;
  final List<TeacherConversationModel> filteredConversations;
  final String searchQuery;
  final String? errorMessage;

  const TeacherConversationsState({
    this.isLoading = false,
    this.conversations = const [],
    this.filteredConversations = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  TeacherConversationsState copyWith({
    bool? isLoading,
    List<TeacherConversationModel>? conversations,
    List<TeacherConversationModel>? filteredConversations,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TeacherConversationsState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      filteredConversations: filteredConversations ?? this.filteredConversations,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        conversations,
        filteredConversations,
        searchQuery,
        errorMessage,
      ];
}
