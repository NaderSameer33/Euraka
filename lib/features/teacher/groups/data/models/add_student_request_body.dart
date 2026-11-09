import 'dart:io';
import 'package:dio/dio.dart';

class AddStudentRequestBody {
  final String fullName;
  final String phone;
  final String parentPhone;
  final int enrollmentPrice;
  final String teacherId;
  final String? email;
  final String? stageId;
  final String? gradeLevelId;
  final File? photoFile;

  const AddStudentRequestBody({
    required this.fullName,
    required this.phone,
    required this.parentPhone,
    this.enrollmentPrice = 300,
    required this.teacherId,
    this.email,
    this.stageId,
    this.gradeLevelId,
    this.photoFile,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'parentPhone': parentPhone,
      'enrollmentPrice': enrollmentPrice.toString(),
      'teacherId': teacherId,
    };

    if (email != null && email!.trim().isNotEmpty) {
      map['email'] = email!.trim();
    } else {
      final sanitizedPhone = phone.replaceAll(RegExp(r'\D'), '');
      map['email'] = 'student.$sanitizedPhone@eureka-lms.com';
    }

    if (stageId != null && stageId!.isNotEmpty) {
      map['stageId'] = stageId;
    }

    if (gradeLevelId != null && gradeLevelId!.isNotEmpty) {
      map['gradeLevelId'] = gradeLevelId;
    }

    if (photoFile != null) {
      final fileName = photoFile!.path.split(Platform.isWindows ? r'\' : '/').last;
      map['teacherPhoto'] = await MultipartFile.fromFile(
        photoFile!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'parentPhone': parentPhone,
      'enrollmentPrice': enrollmentPrice,
      'teacherId': teacherId,
    };
    if (email != null && email!.trim().isNotEmpty) {
      map['email'] = email!.trim();
    }
    if (stageId != null) map['stageId'] = stageId;
    if (gradeLevelId != null) map['gradeLevelId'] = gradeLevelId;
    return map;
  }
}
