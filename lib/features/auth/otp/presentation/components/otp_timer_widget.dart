import 'package:flutter/material.dart';
import '../../../../../core/theme/app_styles.dart';

class OtpTimerWidget extends StatelessWidget {
  final int remainingSeconds;

  const OtpTimerWidget({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final formatted = '$minutes:$seconds';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'سينتهي الرمز خلال ',
          style: AppStyles.font14Regular(context),
        ),
        Text(
          formatted,
          style: AppStyles.font14MediumPrimary,
        ),
      ],
    );
  }
}
