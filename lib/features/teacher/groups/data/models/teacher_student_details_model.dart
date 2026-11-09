import '../../../../../core/constants/app_constants.dart';

class TeacherStudentDetailsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherStudentDetailsData? data;

  const TeacherStudentDetailsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory TeacherStudentDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TeacherStudentDetailsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TeacherStudentDetailsData {
  final StudentDetailedInfo studentInfo;
  final TeacherMiniInfo? teacher;
  final List<EnrolledGroupInfo> enrolledGroups;
  final AttendanceStatsInfo attendanceStats;
  final AcademicPerformanceInfo academicPerformance;
  final FinancialLedgerInfo financialLedger;
  final bool isPaid;
  final String paymentStatus;

  const TeacherStudentDetailsData({
    required this.studentInfo,
    this.teacher,
    this.enrolledGroups = const [],
    required this.attendanceStats,
    required this.academicPerformance,
    required this.financialLedger,
    this.isPaid = false,
    this.paymentStatus = 'غير مدفوع',
  });

  factory TeacherStudentDetailsData.fromJson(
    Map<String, dynamic> json, {
    bool? defaultIsPaid,
    String? defaultPaymentStatus,
  }) {
    final ledger = FinancialLedgerInfo.fromJson(
      json['financialLedger'] as Map<String, dynamic>? ?? {},
    );
    final calculatedIsPaid = defaultIsPaid ??
        (json['isPaid'] as bool? ?? (ledger.totalPaid > 0));
    final calculatedStatus = defaultPaymentStatus ??
        (json['paymentStatus'] as String? ??
            (calculatedIsPaid ? 'مدفوع' : 'غير مدفوع'));

    return TeacherStudentDetailsData(
      studentInfo: StudentDetailedInfo.fromJson(
        json['studentInfo'] as Map<String, dynamic>? ?? {},
      ),
      teacher: json['teacher'] != null && json['teacher'] is Map<String, dynamic>
          ? TeacherMiniInfo.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      enrolledGroups: (json['enrolledGroups'] as List<dynamic>?)
              ?.map((e) => EnrolledGroupInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attendanceStats: AttendanceStatsInfo.fromJson(
        json['attendanceStats'] as Map<String, dynamic>? ?? {},
      ),
      academicPerformance: AcademicPerformanceInfo.fromJson(
        json['academicPerformance'] as Map<String, dynamic>? ?? {},
      ),
      financialLedger: ledger,
      isPaid: calculatedIsPaid,
      paymentStatus: calculatedStatus,
    );
  }

  TeacherStudentDetailsData copyWith({
    StudentDetailedInfo? studentInfo,
    TeacherMiniInfo? teacher,
    List<EnrolledGroupInfo>? enrolledGroups,
    AttendanceStatsInfo? attendanceStats,
    AcademicPerformanceInfo? academicPerformance,
    FinancialLedgerInfo? financialLedger,
    bool? isPaid,
    String? paymentStatus,
  }) {
    return TeacherStudentDetailsData(
      studentInfo: studentInfo ?? this.studentInfo,
      teacher: teacher ?? this.teacher,
      enrolledGroups: enrolledGroups ?? this.enrolledGroups,
      attendanceStats: attendanceStats ?? this.attendanceStats,
      academicPerformance: academicPerformance ?? this.academicPerformance,
      financialLedger: financialLedger ?? this.financialLedger,
      isPaid: isPaid ?? this.isPaid,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  static TeacherStudentDetailsData dummy() {
    return const TeacherStudentDetailsData(
      studentInfo: StudentDetailedInfo(
        id: 'dummy',
        fullName: 'طالب في المجموعة',
        phone: '01000000000',
        parentPhone: '01000000000',
        stageName: 'المرحلة الدراسية',
        gradeLevelName: 'الصف الدراسي',
      ),
      attendanceStats: AttendanceStatsInfo(
        attendanceRatePercentage: 100,
        absencesCount: 0,
        totalSessions: 10,
      ),
      academicPerformance: AcademicPerformanceInfo(
        lastExamScore: '95%',
        lastHomeworkScore: '100%',
        examsCount: 2,
        homeworksCount: 5,
      ),
      financialLedger: FinancialLedgerInfo(
        totalPaid: 300,
        recentPayments: [],
      ),
      isPaid: true,
      paymentStatus: 'مدفوع',
    );
  }
}

class StudentDetailedInfo {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String parentPhone;
  final String? avatarUrl;
  final String stageName;
  final String gradeLevelName;
  final String? gradeLevelId;

  const StudentDetailedInfo({
    required this.id,
    this.userId = '',
    required this.fullName,
    required this.phone,
    this.email = '',
    this.parentPhone = '',
    this.avatarUrl,
    this.stageName = '',
    this.gradeLevelName = '',
    this.gradeLevelId,
  });

  factory StudentDetailedInfo.fromJson(Map<String, dynamic> json) {
    final stage = json['stage'] as Map<String, dynamic>?;
    final gradeLevel = json['gradeLevel'] as Map<String, dynamic>?;

    return StudentDetailedInfo(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      parentPhone: json['parentPhone'] as String? ?? '',
      avatarUrl: AppConstants.formatImageUrl(json['avatarUrl'] as String?),
      stageName: stage?['nameAr'] as String? ?? '',
      gradeLevelName: gradeLevel?['nameAr'] as String? ?? '',
      gradeLevelId: gradeLevel?['id'] as String?,
    );
  }

  StudentDetailedInfo copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phone,
    String? email,
    String? parentPhone,
    String? avatarUrl,
    String? stageName,
    String? gradeLevelName,
    String? gradeLevelId,
  }) {
    return StudentDetailedInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      parentPhone: parentPhone ?? this.parentPhone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      stageName: stageName ?? this.stageName,
      gradeLevelName: gradeLevelName ?? this.gradeLevelName,
      gradeLevelId: gradeLevelId ?? this.gradeLevelId,
    );
  }
}

class TeacherMiniInfo {
  final String id;
  final String fullName;
  final String? avatarUrl;

  const TeacherMiniInfo({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  factory TeacherMiniInfo.fromJson(Map<String, dynamic> json) {
    return TeacherMiniInfo(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      avatarUrl: AppConstants.formatImageUrl(json['avatarUrl'] as String?),
    );
  }
}

class EnrolledGroupInfo {
  final String groupId;
  final String groupName;
  final String subjectName;
  final int enrollmentPrice;
  final String? joinedAt;

  const EnrolledGroupInfo({
    required this.groupId,
    required this.groupName,
    this.subjectName = '',
    this.enrollmentPrice = 0,
    this.joinedAt,
  });

  factory EnrolledGroupInfo.fromJson(Map<String, dynamic> json) {
    return EnrolledGroupInfo(
      groupId: json['groupId'] as String? ?? '',
      groupName: json['groupName'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      enrollmentPrice: json['enrollmentPrice'] as int? ?? 0,
      joinedAt: json['joinedAt'] as String?,
    );
  }
}

class AttendanceStatsInfo {
  final int attendanceRatePercentage;
  final int absencesCount;
  final int totalSessions;

  const AttendanceStatsInfo({
    this.attendanceRatePercentage = 100,
    this.absencesCount = 0,
    this.totalSessions = 0,
  });

  factory AttendanceStatsInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsInfo(
      attendanceRatePercentage: json['attendanceRatePercentage'] as int? ?? 100,
      absencesCount: json['absencesCount'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
    );
  }
}

class AcademicPerformanceInfo {
  final String lastExamScore;
  final String lastHomeworkScore;
  final int examsCount;
  final int homeworksCount;

  const AcademicPerformanceInfo({
    this.lastExamScore = 'لا يوجد',
    this.lastHomeworkScore = 'لا يوجد',
    this.examsCount = 0,
    this.homeworksCount = 0,
  });

  factory AcademicPerformanceInfo.fromJson(Map<String, dynamic> json) {
    return AcademicPerformanceInfo(
      lastExamScore: json['lastExamScore'] as String? ?? 'لا يوجد',
      lastHomeworkScore: json['lastHomeworkScore'] as String? ?? 'لا يوجد',
      examsCount: json['examsCount'] as int? ?? 0,
      homeworksCount: json['homeworksCount'] as int? ?? 0,
    );
  }
}

class FinancialLedgerInfo {
  final int totalPaid;
  final List<dynamic> recentPayments;

  const FinancialLedgerInfo({
    this.totalPaid = 0,
    this.recentPayments = const [],
  });

  factory FinancialLedgerInfo.fromJson(Map<String, dynamic> json) {
    return FinancialLedgerInfo(
      totalPaid: json['totalPaid'] as int? ?? 0,
      recentPayments: json['recentPayments'] as List<dynamic>? ?? const [],
    );
  }
}

