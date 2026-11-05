class ForgotPasswordResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ForgotPasswordData? data;

  const ForgotPasswordResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ForgotPasswordData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ForgotPasswordData {
  final String email;
  final int expiresInMinutes;

  const ForgotPasswordData({
    required this.email,
    required this.expiresInMinutes,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      email: json['email'] as String? ?? '',
      expiresInMinutes: json['expiresInMinutes'] as int? ?? 10,
    );
  }
}

