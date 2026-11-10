import 'dart:io';
import 'package:dio/dio.dart';

class CreateLessonRequestBody {
  final String subjectId;
  final String unitId;
  final String name;
  final String title;
  final String? description;
  final int lessonOrder;
  final int? durationSeconds;
  final File? videoFile;
  final List<File> attachmentFiles;

  const CreateLessonRequestBody({
    required this.subjectId,
    required this.unitId,
    required this.name,
    required this.title,
    this.description,
    this.lessonOrder = 1,
    this.durationSeconds,
    this.videoFile,
    this.attachmentFiles = const [],
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'subjectId': subjectId,
      'unitId': unitId,
      'name': name.trim(),
      'title': title.trim(),
      'lessonOrder': lessonOrder.toString(),
    };

    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }

    if (durationSeconds != null) {
      map['durationSeconds'] = durationSeconds.toString();
    }

    if (videoFile != null && await videoFile!.exists()) {
      final fileName = videoFile!.path.split(Platform.pathSeparator).last;
      map['video'] = await MultipartFile.fromFile(
        videoFile!.path,
        filename: fileName,
      );
    }

    if (attachmentFiles.isNotEmpty) {
      final filesList = <MultipartFile>[];
      for (final f in attachmentFiles) {
        if (await f.exists()) {
          final fName = f.path.split(Platform.pathSeparator).last;
          filesList.add(await MultipartFile.fromFile(f.path, filename: fName));
        }
      }
      if (filesList.isNotEmpty) {
        map['files'] = filesList.length == 1 ? filesList.first : filesList;
      }
    }

    return FormData.fromMap(map);
  }
}

