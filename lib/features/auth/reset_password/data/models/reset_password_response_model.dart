class ResetPasswordResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;

  const ResetPasswordResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }
}
