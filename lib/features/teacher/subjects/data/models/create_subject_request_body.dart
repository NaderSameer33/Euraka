import 'dart:io';
import 'package:dio/dio.dart';

class CreateSubjectRequestBody {
  final String name;
  final String nameAr;
  final String? nameEn;
  final String gradeLevelId;
  final String description;
  final List<String> groupIds;
  final File? photo;
  final List<String> chapters;

  const CreateSubjectRequestBody({
    required this.name,
    required this.nameAr,
    this.nameEn,
    required this.gradeLevelId,
    required this.description,
    this.groupIds = const [],
    this.photo,
    this.chapters = const [],
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'name': name,
      'nameAr': nameAr,
      'gradeLevelId': gradeLevelId,
      'description': description,
    };

    if (nameEn != null && nameEn!.trim().isNotEmpty) {
      map['nameEn'] = nameEn!.trim();
    }

    if (groupIds.isNotEmpty) {
      map['groupIds'] = groupIds.join(',');
    } else {
      map['groupIds'] = '';
    }

    if (photo != null) {
      final fileName = photo!.path.split(Platform.isWindows ? r'\' : '/').last;
      map['photo'] = await MultipartFile.fromFile(
        photo!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'nameAr': nameAr,
      'gradeLevelId': gradeLevelId,
      'description': description,
      'groupIds': groupIds,
      'chapters': chapters,
    };
    if (nameEn != null && nameEn!.isNotEmpty) {
      map['nameEn'] = nameEn;
    }
    return map;
  }
}
