import 'dart:io';
import 'package:dio/dio.dart';

class CreateGroupRequestBody {
  final String name;
  final String subjectId;
  final String stageId;
  final String gradeLevelId;
  final String teacherId;
  final String scheduleDays;
  final String scheduleTime;
  final int maxCapacity;
  final int defaultPrice;
  final String description;
  final String? groupCode;
  final File? coverFile;
  final File? teacherPhotoFile;

  const CreateGroupRequestBody({
    required this.name,
    required this.subjectId,
    required this.stageId,
    required this.gradeLevelId,
    required this.teacherId,
    this.scheduleDays = 'الأحد,الثلاثاء',
    this.scheduleTime = '05:30 PM',
    this.maxCapacity = 45,
    this.defaultPrice = 300,
    required this.description,
    this.groupCode,
    this.coverFile,
    this.teacherPhotoFile,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'name': name,
      'subjectId': subjectId,
      'stageId': stageId,
      'gradeLevelId': gradeLevelId,
      'teacherId': teacherId,
      'scheduleDays': scheduleDays,
      'scheduleTime': scheduleTime,
      'maxCapacity': maxCapacity.toString(),
      'defaultPrice': defaultPrice.toString(),
      'description': description,
    };
    if (groupCode != null && groupCode!.isNotEmpty) {
      map['groupCode'] = groupCode;
    }
    if (coverFile != null) {
      final fileName = coverFile!.path.split(Platform.isWindows ? r'\' : '/').last;
      map['cover'] = await MultipartFile.fromFile(
        coverFile!.path,
        filename: fileName,
      );
    }
    if (teacherPhotoFile != null) {
      final fileName = teacherPhotoFile!.path.split(Platform.isWindows ? r'\' : '/').last;
      map['teacherPhoto'] = await MultipartFile.fromFile(
        teacherPhotoFile!.path,
        filename: fileName,
      );
    }
    return FormData.fromMap(map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'subjectId': subjectId,
      'stageId': stageId,
      'gradeLevelId': gradeLevelId,
      'teacherId': teacherId,
      'scheduleDays': scheduleDays,
      'scheduleTime': scheduleTime,
      'maxCapacity': maxCapacity,
      'defaultPrice': defaultPrice,
      'description': description,
    };
    if (groupCode != null && groupCode!.isNotEmpty) {
      map['groupCode'] = groupCode;
    }
    return map;
  }
}
