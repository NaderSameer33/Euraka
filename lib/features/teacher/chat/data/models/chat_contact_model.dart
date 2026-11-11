import 'package:equatable/equatable.dart';
import '../../../../../core/constants/app_constants.dart';

class ChatContactModel extends Equatable {
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String? studentProfileId;
  final String groupId;
  final String groupName;
  final String subjectName;
  final String? conversationId;
  final int unreadCount;
  final String? lastMessage;
  final String? lastMessageAt;

  const ChatContactModel({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.studentProfileId,
    required this.groupId,
    required this.groupName,
    required this.subjectName,
    this.conversationId,
    this.unreadCount = 0,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;
    final groupMap = json['group'] as Map<String, dynamic>?;

    return ChatContactModel(
      userId: userMap?['id'] as String? ?? json['userId'] as String? ?? '',
      fullName: userMap?['fullName'] as String? ?? json['fullName'] as String? ?? '',
      avatarUrl: AppConstants.formatImageUrl(userMap?['avatarUrl'] as String?),
      studentProfileId: userMap?['studentProfileId'] as String?,
      groupId: groupMap?['id'] as String? ?? json['groupId'] as String? ?? '',
      groupName: groupMap?['name'] as String? ?? json['groupName'] as String? ?? '',
      subjectName: groupMap?['subjectName'] as String? ?? json['subjectName'] as String? ?? '',
      conversationId: json['conversationId'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        avatarUrl,
        studentProfileId,
        groupId,
        groupName,
        subjectName,
        conversationId,
        unreadCount,
        lastMessage,
        lastMessageAt,
      ];
}

