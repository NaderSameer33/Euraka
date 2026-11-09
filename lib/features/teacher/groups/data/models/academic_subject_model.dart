class AcademicSubjectResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AcademicSubjectModel> data;

  const AcademicSubjectResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AcademicSubjectResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?)
            ?.map((e) => AcademicSubjectModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AcademicSubjectResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: list,
    );
  }
}

class AcademicSubjectModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;
  final bool isGlobal;

  const AcademicSubjectModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.iconUrl,
    this.isGlobal = true,
  });

  factory AcademicSubjectModel.fromJson(Map<String, dynamic> json) {
    return AcademicSubjectModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      iconUrl: json['iconUrl'] as String?,
      isGlobal: json['isGlobal'] as bool? ?? true,
    );
  }
}

