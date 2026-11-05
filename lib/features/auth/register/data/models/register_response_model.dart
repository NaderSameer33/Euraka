class RegisterResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final RegisterData? data;

  const RegisterResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RegisterData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RegisterData {
  final RegisterUserModel user;
  final String? token;
  final String? refreshToken;

  const RegisterData({
    required this.user,
    this.token,
    this.refreshToken,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: RegisterUserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}

class RegisterUserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? avatarUrl;
  final bool isVerified;
  final bool isActive;

  const RegisterUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
    this.isActive = true,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

