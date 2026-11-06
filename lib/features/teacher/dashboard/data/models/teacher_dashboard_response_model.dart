class TeacherDashboardResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final TeacherDashboardData? data;

  const TeacherDashboardResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory TeacherDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TeacherDashboardData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TeacherDashboardData {
  final TeacherKpisModel kpis;
  final List<TeacherActiveExamModel> activeExams;
  final List<TeacherRecentGroupModel> recentGroups;

  const TeacherDashboardData({
    required this.kpis,
    required this.activeExams,
    required this.recentGroups,
  });

  factory TeacherDashboardData.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardData(
      kpis: json['kpis'] != null && json['kpis'] is Map<String, dynamic>
          ? TeacherKpisModel.fromJson(json['kpis'] as Map<String, dynamic>)
          : const TeacherKpisModel(),
      activeExams: (json['activeExams'] as List<dynamic>?)
              ?.map((e) => TeacherActiveExamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentGroups: (json['recentGroups'] as List<dynamic>?)
              ?.map((e) => TeacherRecentGroupModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TeacherKpisModel {
  final int totalStudents;
  final num totalStudentsGrowthPercent;
  final int activeGroupsCount;
  final num activeGroupsGrowthPercent;
  final int activeExamsCount;
  final num activeExamsGrowthPercent;
  final num monthlyCollectedRevenue;
  final num collectionRatePercentage;
  final num collectionGrowthPercent;

  const TeacherKpisModel({
    this.totalStudents = 0,
    this.totalStudentsGrowthPercent = 0,
    this.activeGroupsCount = 0,
    this.activeGroupsGrowthPercent = 0,
    this.activeExamsCount = 0,
    this.activeExamsGrowthPercent = 0,
    this.monthlyCollectedRevenue = 0,
    this.collectionRatePercentage = 0,
    this.collectionGrowthPercent = 0,
  });

  factory TeacherKpisModel.fromJson(Map<String, dynamic> json) {
    return TeacherKpisModel(
      totalStudents: json['totalStudents'] as int? ?? 0,
      totalStudentsGrowthPercent: json['totalStudentsGrowthPercent'] as num? ?? 0,
      activeGroupsCount: json['activeGroupsCount'] as int? ?? 0,
      activeGroupsGrowthPercent: json['activeGroupsGrowthPercent'] as num? ?? 0,
      activeExamsCount: json['activeExamsCount'] as int? ?? 0,
      activeExamsGrowthPercent: json['activeExamsGrowthPercent'] as num? ?? 0,
      monthlyCollectedRevenue: json['monthlyCollectedRevenue'] as num? ?? 0,
      collectionRatePercentage: json['collectionRatePercentage'] as num? ?? 0,
      collectionGrowthPercent: json['collectionGrowthPercent'] as num? ?? 0,
    );
  }
}

class TeacherActiveExamModel {
  final String id;
  final String title;
  final String groupName;
  final String subjectName;
  final String? startTime;
  final String? endTime;
  final int durationMinutes;
  final int submissionsCount;

  const TeacherActiveExamModel({
    required this.id,
    required this.title,
    required this.groupName,
    required this.subjectName,
    this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.submissionsCount = 0,
  });

  factory TeacherActiveExamModel.fromJson(Map<String, dynamic> json) {
    return TeacherActiveExamModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      groupName: json['groupName'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      submissionsCount: json['submissionsCount'] as int? ?? 0,
    );
  }
}

class TeacherRecentGroupModel {
  final String id;
  final String name;
  final String subjectName;
  final String gradeLevelName;
  final int studentCount;
  final String? coverImageUrl;

  const TeacherRecentGroupModel({
    required this.id,
    required this.name,
    required this.subjectName,
    required this.gradeLevelName,
    this.studentCount = 0,
    this.coverImageUrl,
  });

  factory TeacherRecentGroupModel.fromJson(Map<String, dynamic> json) {
    return TeacherRecentGroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      gradeLevelName: json['gradeLevelName'] as String? ?? '',
      studentCount: json['studentCount'] as int? ?? 0,
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }
}

