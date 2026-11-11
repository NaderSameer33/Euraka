import 'package:equatable/equatable.dart';
import '../../../../../core/constants/app_constants.dart';

class TeacherConversationModel extends Equatable {
  final String id;
  final String groupId;
  final String groupName;
  final String subjectName;
  final String studentId;
  final String studentName;
  final String? studentAvatarUrl;
  final String? studentPhone;
  final String? lastMessageContent;
  final String? lastMessageAt;
  final String? lastMessageSenderRole;
  final int unreadCount;
  final bool isOnline;

  const TeacherConversationModel({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.subjectName,
    required this.studentId,
    required this.studentName,
    this.studentAvatarUrl,
    this.studentPhone,
    this.lastMessageContent,
    this.lastMessageAt,
    this.lastMessageSenderRole,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory TeacherConversationModel.fromJson(Map<String, dynamic> json) {
    final studentMap = json['student'] is Map ? json['student'] as Map : null;
    final participantMap = json['participant'] is Map ? json['participant'] as Map : null;
    final groupMap = json['group'] is Map ? json['group'] as Map : null;

    final studentName = studentMap?['fullName']?.toString() ??
        participantMap?['fullName']?.toString() ??
        json['studentName']?.toString() ??
        'طالب';

    final rawAvatar = studentMap?['avatarUrl']?.toString() ??
        participantMap?['avatarUrl']?.toString() ??
        json['studentAvatarUrl']?.toString();

    String? lastMessageContent;
    String? lastMessageAt = json['lastMessageAt']?.toString();
    String? lastMessageSenderRole;

    if (json['lastMessage'] is Map) {
      final lastMsgMap = json['lastMessage'] as Map;
      lastMessageContent = lastMsgMap['content']?.toString();
      lastMessageAt = lastMsgMap['createdAt']?.toString() ?? lastMessageAt;
      lastMessageSenderRole = lastMsgMap['senderRole']?.toString();
    } else if (json['lastMessage'] != null) {
      lastMessageContent = json['lastMessage'].toString();
    }

    return TeacherConversationModel(
      id: json['id']?.toString() ?? '',
      groupId: json['groupId']?.toString() ?? groupMap?['id']?.toString() ?? '',
      groupName: json['groupName']?.toString() ?? groupMap?['name']?.toString() ?? '',
      subjectName: json['subjectName']?.toString() ?? groupMap?['subjectName']?.toString() ?? '',
      studentId: studentMap?['id']?.toString() ??
          participantMap?['id']?.toString() ??
          json['studentId']?.toString() ??
          '',
      studentName: studentName,
      studentAvatarUrl: AppConstants.formatImageUrl(rawAvatar),
      studentPhone: studentMap?['phone']?.toString(),
      lastMessageContent: lastMessageContent,
      lastMessageAt: lastMessageAt,
      lastMessageSenderRole: lastMessageSenderRole,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  TeacherConversationModel copyWith({
    String? id,
    String? groupId,
    String? groupName,
    String? subjectName,
    String? studentId,
    String? studentName,
    String? studentAvatarUrl,
    String? studentPhone,
    String? lastMessageContent,
    String? lastMessageAt,
    String? lastMessageSenderRole,
    int? unreadCount,
    bool? isOnline,
  }) {
    return TeacherConversationModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      subjectName: subjectName ?? this.subjectName,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentAvatarUrl: studentAvatarUrl ?? this.studentAvatarUrl,
      studentPhone: studentPhone ?? this.studentPhone,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageSenderRole: lastMessageSenderRole ?? this.lastMessageSenderRole,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        groupName,
        subjectName,
        studentId,
        studentName,
        studentAvatarUrl,
        studentPhone,
        lastMessageContent,
        lastMessageAt,
        lastMessageSenderRole,
        unreadCount,
        isOnline,
      ];
}
