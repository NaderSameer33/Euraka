import '../../../../../core/constants/app_constants.dart';

class SubjectUnitModel {
  final String id;
  final String subjectId;
  final String gradeLevelId;
  final String title;
  final int order;
  final int unitNumber;
  final String? photoUrl;
  final String? description;
  final List<UnitLessonModel> lessons;
  final int chaptersCount;
  final int videosCount;

  const SubjectUnitModel({
    required this.id,
    required this.subjectId,
    required this.gradeLevelId,
    required this.title,
    this.order = 1,
    this.unitNumber = 1,
    this.photoUrl,
    this.description,
    this.lessons = const [],
    this.chaptersCount = 0,
    this.videosCount = 0,
  });

  factory SubjectUnitModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = (json['lessons'] as List<dynamic>?)
            ?.map((e) => UnitLessonModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final rawOrder = json['order'] as int? ?? (json['unitNumber'] as int? ?? 1);
    final rawUnitNumber = json['unitNumber'] as int? ?? rawOrder;
    final count = json['_count'] as Map<String, dynamic>?;
    final chCount = count?['chapters'] as int? ??
        count?['lessons'] as int? ??
        (json['chaptersCount'] as int? ?? rawLessons.length);
    final vidCount = count?['videos'] as int? ??
        (json['videosCount'] as int? ??
            rawLessons.fold<int>(0, (sum, l) => sum + l.videoCount));

    return SubjectUnitModel(
      id: json['id'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      gradeLevelId: json['gradeLevelId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      order: rawOrder,
      unitNumber: rawUnitNumber,
      photoUrl: AppConstants.formatImageUrl(json['photoUrl'] as String?),
      description: json['description'] as String?,
      lessons: rawLessons,
      chaptersCount: chCount,
      videosCount: vidCount,
    );
  }

  static List<SubjectUnitModel> dummyList({String subjectName = 'الرياضيات'}) {
    return [
      SubjectUnitModel(
        id: '1',
        subjectId: '1',
        gradeLevelId: '1',
        title: 'الجبر',
        unitNumber: 1,
        description: 'مفاهيم الجبر الأساسية',
        chaptersCount: 5,
        videosCount: 10,
      ),
      SubjectUnitModel(
        id: '2',
        subjectId: '1',
        gradeLevelId: '1',
        title: 'الهندسة',
        unitNumber: 2,
        description: 'الأشكال الهندسية والمساحات',
        chaptersCount: 4,
        videosCount: 15,
      ),
      SubjectUnitModel(
        id: '3',
        subjectId: '1',
        gradeLevelId: '1',
        title: 'التفاضل والتكامل',
        unitNumber: 3,
        description: 'أساسيات التفاضل والتكامل',
        chaptersCount: 4,
        videosCount: 15,
      ),
      SubjectUnitModel(
        id: '4',
        subjectId: '1',
        gradeLevelId: '1',
        title: 'الاحتمالات والإحصاء',
        unitNumber: 4,
        description: 'مبادئ الاحتمالات والإحصاء',
        chaptersCount: 4,
        videosCount: 15,
      ),
      SubjectUnitModel(
        id: '5',
        subjectId: '1',
        gradeLevelId: '1',
        title: 'المثلثات',
        unitNumber: 5,
        description: 'قوانين الدوال المثلثية',
        chaptersCount: 4,
        videosCount: 15,
      ),
    ];
  }
}

class UnitLessonModel {
  final String id;
  final String title;
  final String chapterTitle;
  final int lessonNumber;
  final int pdfCount;
  final int videoCount;

  const UnitLessonModel({
    required this.id,
    required this.title,
    this.chapterTitle = 'الفصل الأول',
    this.lessonNumber = 1,
    this.pdfCount = 0,
    this.videoCount = 0,
  });

  factory UnitLessonModel.fromJson(Map<String, dynamic> json) {
    final materialsList = json['materials'] as List<dynamic>?;
    final videosList = json['videos'] as List<dynamic>?;
    final count = json['_count'] as Map<String, dynamic>?;

    final derivedPdfCount = materialsList != null
        ? materialsList.where((m) {
            if (m is Map) {
              final type = (m['fileType'] as String? ?? m['type'] as String? ?? '').toLowerCase();
              final name = (m['title'] as String? ?? m['name'] as String? ?? '').toLowerCase();
              return type.contains('pdf') || name.contains('pdf');
            }
            return true;
          }).length
        : (count?['materials'] as int? ??
            (count?['pdf'] as int? ??
                (json['pdfCount'] as int? ?? (json['materialsCount'] as int? ?? 0))));

    final derivedVideoCount = videosList != null
        ? videosList.length
        : (count?['videos'] as int? ??
            (json['videoCount'] as int? ?? (json['videosCount'] as int? ?? 0)));

    return UnitLessonModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? (json['name'] as String? ?? ''),
      chapterTitle: json['chapterTitle'] as String? ?? 'الفصل الأول',
      lessonNumber: json['lessonNumber'] as int? ?? (json['order'] as int? ?? 1),
      pdfCount: derivedPdfCount,
      videoCount: derivedVideoCount,
    );
  }
}

