class ResetPasswordRequestBody {
  final String email;
  final String? resetToken;
  final String newPassword;
  final String confirmPassword;
  final String? currentPassword;

  const ResetPasswordRequestBody({
    required this.email,
    this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
    this.currentPassword,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
    if (resetToken != null && resetToken!.isNotEmpty) {
      map['resetToken'] = resetToken;
    }
    if (currentPassword != null && currentPassword!.isNotEmpty) {
      map['currentPassword'] = currentPassword;
    }
    return map;
  }
}
