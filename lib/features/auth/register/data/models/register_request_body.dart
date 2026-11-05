class RegisterRequestBody {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterRequestBody({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'password': password,
    'confirmPassword': confirmPassword,
    'role': role,
  };
}

