import 'package:equatable/equatable.dart';
import '../../../../../core/constants/app_constants.dart';

class ChatMessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? receiverId;
  final String senderRole;
  final String? senderName;
  final String? senderAvatarUrl;
  final String content;
  final String? attachmentUrl;
  final bool isRead;
  final String createdAt;
  final bool isMine;
  final String? clientMessageId;
  final bool isSending;
  final bool hasFailed;

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.receiverId,
    this.senderRole = 'TEACHER',
    this.senderName,
    this.senderAvatarUrl,
    required this.content,
    this.attachmentUrl,
    this.isRead = false,
    required this.createdAt,
    required this.isMine,
    this.clientMessageId,
    this.isSending = false,
    this.hasFailed = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderMap = json['sender'] is Map ? json['sender'] as Map : null;

    return ChatMessageModel(
      id: json['id']?.toString() ?? json['messageId']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? senderMap?['id']?.toString() ?? '',
      receiverId: json['receiverId']?.toString(),
      senderRole: json['senderRole']?.toString() ?? 'TEACHER',
      senderName: senderMap?['fullName']?.toString() ?? json['senderName']?.toString(),
      senderAvatarUrl: AppConstants.formatImageUrl(senderMap?['avatarUrl']?.toString()),
      content: json['content']?.toString() ?? '',
      attachmentUrl: json['attachmentUrl']?.toString(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      isMine: json['isMine'] as bool? ?? (json['senderRole'] == 'TEACHER'),
      clientMessageId: json['clientMessageId']?.toString(),
      isSending: false,
      hasFailed: false,
    );
  }

  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? senderRole,
    String? senderName,
    String? senderAvatarUrl,
    String? content,
    String? attachmentUrl,
    bool? isRead,
    String? createdAt,
    bool? isMine,
    String? clientMessageId,
    bool? isSending,
    bool? hasFailed,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderRole: senderRole ?? this.senderRole,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      isSending: isSending ?? this.isSending,
      hasFailed: hasFailed ?? this.hasFailed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        receiverId,
        senderRole,
        senderName,
        senderAvatarUrl,
        content,
        attachmentUrl,
        isRead,
        createdAt,
        isMine,
        clientMessageId,
        isSending,
        hasFailed,
      ];
}
