import '../../../../../core/constants/app_constants.dart';
import 'lesson_model.dart';

class LessonVideoDetailsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final LessonVideoDetailsData? data;

  const LessonVideoDetailsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory LessonVideoDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return LessonVideoDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? LessonVideoDetailsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LessonVideoDetailsData {
  final String id;
  final String lessonId;
  final String name;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? description;
  final int durationSeconds;
  final int order;
  final String? lessonTitle;
  final String? unitTitle;
  final String? subjectName;
  final List<LessonMaterialModel> materials;

  const LessonVideoDetailsData({
    required this.id,
    required this.lessonId,
    required this.name,
    this.videoUrl,
    this.thumbnailUrl,
    this.description,
    this.durationSeconds = 0,
    this.order = 1,
    this.lessonTitle,
    this.unitTitle,
    this.subjectName,
    this.materials = const [],
  });

  String get formattedDuration {
    if (durationSeconds <= 0) return '00:00';
    final minutes = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String? get formattedVideoUrl => AppConstants.formatImageUrl(videoUrl);
  String? get formattedThumbnailUrl => AppConstants.formatImageUrl(thumbnailUrl);

  String get breadcrumb {
    final parts = <String>[];
    if (subjectName != null && subjectName!.isNotEmpty) parts.add(subjectName!);
    if (unitTitle != null && unitTitle!.isNotEmpty) parts.add(unitTitle!);
    if (lessonTitle != null && lessonTitle!.isNotEmpty) parts.add(lessonTitle!);
    return parts.join(' > ');
  }

  factory LessonVideoDetailsData.fromJson(Map<String, dynamic> json) {
    final lessonObj = json['lesson'] as Map<String, dynamic>?;
    final unitObj = lessonObj?['unit'] as Map<String, dynamic>?;
    final subObj = unitObj?['subject'] as Map<String, dynamic>?;

    final mats = (json['materials'] as List<dynamic>?)
            ?.map((e) => LessonMaterialModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        (lessonObj?['materials'] as List<dynamic>?)
            ?.map((e) => LessonMaterialModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    return LessonVideoDetailsData(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? (lessonObj?['id'] as String? ?? ''),
      name: json['name'] as String? ?? '',
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? json['coverUrl'] as String?,
      description: json['description'] as String?,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      order: json['order'] as int? ?? 1,
      lessonTitle: lessonObj?['title'] as String? ?? lessonObj?['name'] as String?,
      unitTitle: unitObj?['title'] as String?,
      subjectName: subObj?['nameAr'] as String? ?? subObj?['name'] as String?,
      materials: mats,
    );
  }
}
