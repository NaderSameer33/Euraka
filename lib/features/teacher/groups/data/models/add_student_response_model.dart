class AddStudentResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final AddStudentData? data;

  const AddStudentResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory AddStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return AddStudentResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AddStudentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AddStudentData {
  final String message;
  final CreatedStudentModel? student;

  const AddStudentData({
    required this.message,
    this.student,
  });

  factory AddStudentData.fromJson(Map<String, dynamic> json) {
    return AddStudentData(
      message: json['message'] as String? ?? '',
      student: json['student'] != null && json['student'] is Map<String, dynamic>
          ? CreatedStudentModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CreatedStudentModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String parentPhone;
  final bool isNewAccount;

  const CreatedStudentModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.parentPhone,
    this.isNewAccount = false,
  });

  factory CreatedStudentModel.fromJson(Map<String, dynamic> json) {
    return CreatedStudentModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      parentPhone: json['parentPhone'] as String? ?? '',
      isNewAccount: json['isNewAccount'] as bool? ?? false,
    );
  }
}

