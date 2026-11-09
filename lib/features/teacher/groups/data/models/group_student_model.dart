import '../../../../../core/constants/app_constants.dart';

class GroupStudentModel {
  final String enrollmentId;
  final String studentId;
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String parentPhone;
  final String? avatarUrl;
  final String? joinedAt;
  final int enrollmentPrice;
  final String paymentStatus;
  final bool isPaid;
  final int totalPaidThisMonth;
  final int attendanceRatePercentage;
  final String lastExamScore;

  const GroupStudentModel({
    required this.enrollmentId,
    required this.studentId,
    required this.userId,
    required this.fullName,
    required this.phone,
    this.email = '',
    this.parentPhone = '',
    this.avatarUrl,
    this.joinedAt,
    this.enrollmentPrice = 0,
    this.paymentStatus = 'غير مدفوع',
    this.isPaid = false,
    this.totalPaidThisMonth = 0,
    this.attendanceRatePercentage = 100,
    this.lastExamScore = 'لا يوجد',
  });

  factory GroupStudentModel.fromJson(Map<String, dynamic> json) {
    return GroupStudentModel(
      enrollmentId: json['enrollmentId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      parentPhone: json['parentPhone'] as String? ?? '',
      avatarUrl: AppConstants.formatImageUrl(json['avatarUrl'] as String?),
      joinedAt: json['joinedAt'] as String?,
      enrollmentPrice: json['enrollmentPrice'] as int? ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? 'غير مدفوع',
      isPaid: json['isPaid'] as bool? ?? false,
      totalPaidThisMonth: json['totalPaidThisMonth'] as int? ?? 0,
      attendanceRatePercentage: json['attendanceRatePercentage'] as int? ?? 100,
      lastExamScore: json['lastExamScore'] as String? ?? 'لا يوجد',
    );
  }
}
