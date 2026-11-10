import '../../../../../core/constants/app_constants.dart';

class LessonVideoModel {
  final String id;
  final String lessonId;
  final String name;
  final String? videoUrl;
  final int durationSeconds;
  final String? description;
  final int order;
  final String? thumbnailUrl;

  const LessonVideoModel({
    required this.id,
    required this.lessonId,
    required this.name,
    this.videoUrl,
    this.durationSeconds = 0,
    this.description,
    this.order = 1,
    this.thumbnailUrl,
  });

  String get formattedDuration {
    if (durationSeconds <= 0) return '00:00';
    final minutes = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String? get formattedVideoUrl => AppConstants.formatImageUrl(videoUrl);
  String? get formattedThumbnailUrl => AppConstants.formatImageUrl(thumbnailUrl);

  factory LessonVideoModel.fromJson(Map<String, dynamic> json) {
    return LessonVideoModel(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      name: json['title'] as String? ?? (json['name'] as String? ?? ''),
      videoUrl: json['videoUrl'] as String?,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      description: json['description'] as String?,
      order: json['order'] as int? ?? 1,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}

class LessonMaterialModel {
  final String id;
  final String lessonId;
  final String name;
  final String? fileUrl;
  final String? fileType;
  final int fileSizeBytes;

  const LessonMaterialModel({
    required this.id,
    required this.lessonId,
    required this.name,
    this.fileUrl,
    this.fileType,
    this.fileSizeBytes = 0,
  });

  bool get isPdf {
    final lower = (fileType ?? name).toLowerCase();
    return lower.contains('pdf');
  }

  bool get isImage {
    final lower = (fileType ?? name).toLowerCase();
    return lower.contains('jpg') ||
        lower.contains('jpeg') ||
        lower.contains('png') ||
        lower.contains('webp');
  }

  bool get isVideo {
    final lower = (fileType ?? name).toLowerCase();
    return lower.contains('mp4') ||
        lower.contains('mov') ||
        lower.contains('mkv');
  }

  String get formattedFileSize {
    if (fileSizeBytes <= 0) return '0 KB';
    if (fileSizeBytes < 1024 * 1024) {
      final kb = (fileSizeBytes / 1024).toStringAsFixed(1);
      return '$kb KB';
    }
    final mb = (fileSizeBytes / (1024 * 1024)).toStringAsFixed(1);
    return '$mb MB';
  }

  String? get formattedFileUrl => AppConstants.formatImageUrl(fileUrl);

  factory LessonMaterialModel.fromJson(Map<String, dynamic> json) {
    return LessonMaterialModel(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      name: json['name'] as String? ?? (json['title'] as String? ?? ''),
      fileUrl: json['fileUrl'] as String? ?? json['url'] as String?,
      fileType: json['fileType'] as String? ?? json['type'] as String?,
      fileSizeBytes: json['fileSize'] as int? ?? (json['size'] as int? ?? 0),
    );
  }
}

class TeacherLessonModel {
  final String id;
  final String unitId;
  final String name;
  final String title;
  final String? description;
  final int order;
  final String? createdById;
  final List<LessonVideoModel> videos;
  final List<LessonMaterialModel> materials;
  final String? subjectName;
  final String? unitTitle;
  final String? gradeLevelName;

  const TeacherLessonModel({
    required this.id,
    required this.unitId,
    required this.name,
    required this.title,
    this.description,
    this.order = 1,
    this.createdById,
    this.videos = const [],
    this.materials = const [],
    this.subjectName,
    this.unitTitle,
    this.gradeLevelName,
  });

  String get displayName => title.isNotEmpty ? title : name;

  int get pdfCount {
    final count = materials.where((m) => m.isPdf).length;
    return count > 0 ? count : (materials.isNotEmpty ? materials.length : 0);
  }

  int get videoCount => videos.length;

  String get breadcrumb {
    final parts = <String>[];
    if (subjectName != null && subjectName!.isNotEmpty) parts.add(subjectName!);
    if (unitTitle != null && unitTitle!.isNotEmpty) parts.add(unitTitle!);
    parts.add(displayName);
    return parts.join(' > ');
  }

  factory TeacherLessonModel.fromJson(Map<String, dynamic> json) {
    final vids = (json['videos'] as List<dynamic>?)
            ?.map((e) => LessonVideoModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final mats = (json['materials'] as List<dynamic>?)
            ?.map((e) => LessonMaterialModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final unitObj = json['unit'] as Map<String, dynamic>?;
    final subjectObj = unitObj?['subject'] as Map<String, dynamic>?;
    final gradeObj = unitObj?['gradeLevel'] as Map<String, dynamic>?;

    return TeacherLessonModel(
      id: json['id'] as String? ?? '',
      unitId: json['unitId'] as String? ?? (unitObj?['id'] as String? ?? ''),
      name: json['title'] as String? ?? (json['name'] as String? ?? ''),
      title: json['title'] as String? ?? (json['name'] as String? ?? ''),
      description: json['description'] as String?,
      order: json['order'] as int? ?? (json['lessonOrder'] as int? ?? 1),
      createdById: json['createdById'] as String?,
      videos: vids,
      materials: mats,
      subjectName: subjectObj?['nameAr'] as String? ?? subjectObj?['name'] as String?,
      unitTitle: unitObj?['title'] as String?,
      gradeLevelName: gradeObj?['nameAr'] as String?,
    );
  }
}
