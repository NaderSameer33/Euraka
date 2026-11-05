class LoginResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final LoginData? data;

  const LoginResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LoginData {
  final UserModel user;
  final String token;
  final String? refreshToken;

  const LoginData({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

