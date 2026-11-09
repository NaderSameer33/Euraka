class AcademicStageResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AcademicStageModel> data;

  const AcademicStageResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AcademicStageResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?)
            ?.map((e) => AcademicStageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AcademicStageResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: list,
    );
  }
}

class AcademicStageModel {
  final String id;
  final String key;
  final String nameAr;
  final String nameEn;
  final int order;
  final List<GradeLevelModel> grades;

  const AcademicStageModel({
    required this.id,
    required this.key,
    required this.nameAr,
    required this.nameEn,
    this.order = 0,
    this.grades = const [],
  });

  factory AcademicStageModel.fromJson(Map<String, dynamic> json) {
    final gradesList = (json['grades'] as List<dynamic>?)
            ?.map((e) => GradeLevelModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return AcademicStageModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      grades: gradesList,
    );
  }
}

class GradeLevelModel {
  final String id;
  final String stageId;
  final String nameAr;
  final String nameEn;
  final int gradeNumber;

  const GradeLevelModel({
    required this.id,
    required this.stageId,
    required this.nameAr,
    required this.nameEn,
    this.gradeNumber = 0,
  });

  factory GradeLevelModel.fromJson(Map<String, dynamic> json) {
    return GradeLevelModel(
      id: json['id'] as String? ?? '',
      stageId: json['stageId'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      gradeNumber: json['gradeNumber'] as int? ?? 0,
    );
  }
}

