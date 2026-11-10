import 'dart:io';
import 'package:dio/dio.dart';

class CreateUnitRequestBody {
  final String subjectId;
  final String gradeLevelId;
  final String title;
  final int unitNumber;
  final String? description;
  final String? availableSubjectIds;
  final File? photoFile;
  final List<String> chapters;

  const CreateUnitRequestBody({
    required this.subjectId,
    required this.gradeLevelId,
    required this.title,
    this.unitNumber = 1,
    this.description,
    this.availableSubjectIds,
    this.photoFile,
    this.chapters = const [],
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'subjectId': subjectId,
      'gradeLevelId': gradeLevelId,
      'title': title.trim(),
      'unitNumber': unitNumber.toString(),
    };

    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }

    if (availableSubjectIds != null && availableSubjectIds!.isNotEmpty) {
      map['availableSubjectIds'] = availableSubjectIds;
    } else {
      map['availableSubjectIds'] = subjectId;
    }

    if (photoFile != null && await photoFile!.exists()) {
      final fileName = photoFile!.path.split(Platform.pathSeparator).last;
      map['photo'] = await MultipartFile.fromFile(
        photoFile!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }
}
