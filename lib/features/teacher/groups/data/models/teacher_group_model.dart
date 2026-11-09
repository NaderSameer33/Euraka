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
    this.coverImageUrl,
    this.description,
    this.isFull = false,
    this.createdAt,
  });

  factory TeacherGroupModel.fromJson(Map<String, dynamic> json) {
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
      studentCount: json['studentCount'] as int? ?? 0,
      defaultPrice: json['defaultPrice'] as int? ?? 0,
      coverImageUrl: json['coverImageUrl'] as String?,
      description: json['description'] as String?,
      isFull: json['isFull'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }
}

