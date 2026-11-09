import '../../../../../core/constants/app_constants.dart';

class TeacherGroupModel {
  final String id;
  final String name;
  final String groupCode;
  final String subjectId;
  final String subjectName;
  final String? subjectIcon;
  final String stageName;
  final String gradeLevelName;
  final List<String> scheduleDays;
  final String scheduleTime;
  final int maxCapacity;
  final int studentCount;
  final int defaultPrice;
  final int paidCount;
  final int unpaidCount;
  final String? coverImageUrl;
  final String? description;
  final bool isFull;
  final String? createdAt;

  const TeacherGroupModel({
    required this.id,
    required this.name,
    this.groupCode = '',
    this.subjectId = '',
    this.subjectName = '',
    this.subjectIcon,
    this.stageName = '',
    this.gradeLevelName = '',
    this.scheduleDays = const [],
    this.scheduleTime = '',
    this.maxCapacity = 0,
    this.studentCount = 0,
    this.defaultPrice = 0,
    this.paidCount = 0,
    this.unpaidCount = 0,
    this.coverImageUrl,
    this.description,
    this.isFull = false,
    this.createdAt,
  });

  TeacherGroupModel copyWith({
    String? id,
    String? name,
    String? groupCode,
    String? subjectId,
    String? subjectName,
    String? subjectIcon,
    String? stageName,
    String? gradeLevelName,
    List<String>? scheduleDays,
    String? scheduleTime,
    int? maxCapacity,
    int? studentCount,
    int? defaultPrice,
    int? paidCount,
    int? unpaidCount,
    String? coverImageUrl,
    String? description,
    bool? isFull,
    String? createdAt,
  }) {
    return TeacherGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      groupCode: groupCode ?? this.groupCode,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectIcon: subjectIcon ?? this.subjectIcon,
      stageName: stageName ?? this.stageName,
      gradeLevelName: gradeLevelName ?? this.gradeLevelName,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      studentCount: studentCount ?? this.studentCount,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      paidCount: paidCount ?? this.paidCount,
      unpaidCount: unpaidCount ?? this.unpaidCount,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      isFull: isFull ?? this.isFull,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TeacherGroupModel.fromJson(Map<String, dynamic> json) {
    final count = json['studentCount'] as int? ?? 0;
    final parsedPaid = json['paidCount'] as int? ?? json['paidStudentsCount'] as int? ?? 0;
    final parsedUnpaid = json['unpaidCount'] as int? ?? json['unpaidStudentsCount'] as int? ?? (count > parsedPaid ? count - parsedPaid : 0);

    return TeacherGroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      groupCode: json['groupCode'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      subjectIcon: json['subjectIcon'] as String?,
      stageName: json['stageName'] as String? ?? '',
      gradeLevelName: json['gradeLevelName'] as String? ?? '',
      scheduleDays: (json['scheduleDays'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      scheduleTime: json['scheduleTime'] as String? ?? '',
      maxCapacity: json['maxCapacity'] as int? ?? 0,
      studentCount: count,
      defaultPrice: json['defaultPrice'] as int? ?? 0,
      paidCount: parsedPaid,
      unpaidCount: parsedUnpaid,
      coverImageUrl: AppConstants.formatImageUrl(json['coverImageUrl'] as String?),
      description: json['description'] as String?,
      isFull: json['isFull'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }
}
