import '../../../../../core/constants/app_constants.dart';

class TeacherSubjectModel {
  final String id;
  final String nameAr;
  final String? nameEn;
  final String? iconUrl;
  final String? createdById;
  final bool isGlobal;
  final String? description;
  final String? gradeLevelId;
  final TeacherSubjectGradeLevelModel? gradeLevel;
  final int unitsCount;
  final int groupsCount;
  final List<TeacherSubjectGroupSummary> groups;

  const TeacherSubjectModel({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.iconUrl,
    this.createdById,
    this.isGlobal = false,
    this.description,
    this.gradeLevelId,
    this.gradeLevel,
    this.unitsCount = 0,
    this.groupsCount = 0,
    this.groups = const [],
  });

  String get displayName => nameAr.isNotEmpty ? nameAr : (nameEn ?? '');

  String? get formattedIconUrl => AppConstants.formatImageUrl(iconUrl);

  factory TeacherSubjectModel.fromJson(Map<String, dynamic> json) {
    final count = json['_count'] as Map<String, dynamic>?;
    final units = count?['units'] as int? ?? (json['unitsCount'] as int? ?? 0);
    final groupsNum = count?['groups'] as int? ?? (json['groupsCount'] as int? ?? 0);

    final groupsList = (json['groups'] as List<dynamic>?)
            ?.map((e) => TeacherSubjectGroupSummary.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final gradeLevelObj = json['gradeLevel'] != null
        ? TeacherSubjectGradeLevelModel.fromJson(
            json['gradeLevel'] as Map<String, dynamic>,
          )
        : null;

    final gradeId = json['gradeLevelId'] as String? ?? gradeLevelObj?.id;

    return TeacherSubjectModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? json['name'] as String? ?? '',
      nameEn: json['nameEn'] as String?,
      iconUrl: json['iconUrl'] as String?,
      createdById: json['createdById'] as String?,
      isGlobal: json['isGlobal'] as bool? ?? false,
      description: json['description'] as String?,
      gradeLevelId: gradeId,
      gradeLevel: gradeLevelObj,
      unitsCount: units,
      groupsCount: groupsNum > 0 ? groupsNum : groupsList.length,
      groups: groupsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'iconUrl': iconUrl,
      'createdById': createdById,
      'isGlobal': isGlobal,
      'description': description,
      'gradeLevelId': gradeLevelId,
      'gradeLevel': gradeLevel?.toJson(),
      '_count': {
        'units': unitsCount,
        'groups': groupsCount,
      },
      'groups': groups.map((e) => e.toJson()).toList(),
    };
  }
}

class TeacherSubjectGradeLevelModel {
  final String id;
  final String? stageId;
  final String nameAr;
  final String? nameEn;
  final int? gradeNumber;

  const TeacherSubjectGradeLevelModel({
    required this.id,
    this.stageId,
    required this.nameAr,
    this.nameEn,
    this.gradeNumber,
  });

  factory TeacherSubjectGradeLevelModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectGradeLevelModel(
      id: json['id'] as String? ?? '',
      stageId: json['stageId'] as String?,
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String?,
      gradeNumber: json['gradeNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stageId': stageId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'gradeNumber': gradeNumber,
    };
  }
}

class TeacherSubjectGroupSummary {
  final String id;
  final String name;
  final String? groupCode;

  const TeacherSubjectGroupSummary({
    required this.id,
    required this.name,
    this.groupCode,
  });

  factory TeacherSubjectGroupSummary.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectGroupSummary(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      groupCode: json['groupCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'groupCode': groupCode,
    };
  }
}
