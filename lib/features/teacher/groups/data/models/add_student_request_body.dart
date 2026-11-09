class AddStudentRequestBody {
  final String fullName;
  final String phone;
  final String? email;
  final String parentPhone;
  final int enrollmentPrice;

  const AddStudentRequestBody({
    required this.fullName,
    required this.phone,
    this.email,
    required this.parentPhone,
    this.enrollmentPrice = 300,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'parentPhone': parentPhone,
      'enrollmentPrice': enrollmentPrice,
    };
    if (email != null && email!.trim().isNotEmpty) {
      map['email'] = email!.trim();
    }
    return map;
  }
}

