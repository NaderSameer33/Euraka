class CreateGroupRequestBody {
  final String name;
  final String subjectId;
  final String stageId;
  final String gradeLevelId;
  final String scheduleDays;
  final String scheduleTime;
  final int maxCapacity;
  final int defaultPrice;
  final String description;

  const CreateGroupRequestBody({
    required this.name,
    required this.subjectId,
    required this.stageId,
    required this.gradeLevelId,
    this.scheduleDays = 'الأحد,الثلاثاء',
    this.scheduleTime = '05:30 PM',
    this.maxCapacity = 45,
    this.defaultPrice = 300,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subjectId': subjectId,
      'stageId': stageId,
      'gradeLevelId': gradeLevelId,
      'scheduleDays': scheduleDays,
      'scheduleTime': scheduleTime,
      'maxCapacity': maxCapacity,
      'defaultPrice': defaultPrice,
      'description': description,
    };
  }
}

