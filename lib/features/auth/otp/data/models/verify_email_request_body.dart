class VerifyEmailRequestBody {
  final String otpCode;

  const VerifyEmailRequestBody({
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
    'otpCode': otpCode,
  };
}
