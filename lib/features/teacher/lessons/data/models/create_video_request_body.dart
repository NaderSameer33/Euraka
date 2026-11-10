import 'dart:io';
import 'package:dio/dio.dart';

class CreateVideoRequestBody {
  final String lessonId;
  final String name;
  final String? description;
  final int? durationSeconds;
  final File videoFile;
  final String? groupId;

  const CreateVideoRequestBody({
    required this.lessonId,
    required this.name,
    this.description,
    this.durationSeconds,
    required this.videoFile,
    this.groupId,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'lessonId': lessonId,
      'name': name.trim(),
    };

    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }

    if (durationSeconds != null) {
      map['durationSeconds'] = durationSeconds.toString();
    }

    if (groupId != null && groupId!.isNotEmpty) {
      map['groupId'] = groupId;
    }

    final fileName = videoFile.path.split(Platform.pathSeparator).last;
    map['video'] = await MultipartFile.fromFile(
      videoFile.path,
      filename: fileName,
    );

    return FormData.fromMap(map);
  }
}

