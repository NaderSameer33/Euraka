import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_button.dart';

class RoleSelectionBottomBar extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onConfirm;

  const RoleSelectionBottomBar({
    super.key,
    required this.isEnabled,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: AppButton(
        text: 'متابعة',
        onPressed: isEnabled ? onConfirm : null,
      ),
    );
  }
}

