class VerifyEmailResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;

  const VerifyEmailResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }
}

