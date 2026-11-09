import 'dart:io';
import 'package:dio/dio.dart';

class EditStudentRequestBody {
  final String? fullName;
  final String? parentPhone;
  final String? gradeLevelId;
  final File? avatarFile;

  const EditStudentRequestBody({
    this.fullName,
    this.parentPhone,
    this.gradeLevelId,
    this.avatarFile,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    if (fullName != null && fullName!.trim().isNotEmpty) {
      map['fullName'] = fullName!.trim();
    }
    if (parentPhone != null && parentPhone!.trim().isNotEmpty) {
      map['parentPhone'] = parentPhone!.trim();
    }
    if (gradeLevelId != null && gradeLevelId!.trim().isNotEmpty) {
      map['gradeLevelId'] = gradeLevelId!.trim();
    }
    if (avatarFile != null && await avatarFile!.exists()) {
      final fileName = avatarFile!.path.split(Platform.pathSeparator).last;
      map['avatar'] = await MultipartFile.fromFile(
        avatarFile!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }
}

