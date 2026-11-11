import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_styles.dart';

class HomeworkSummaryItemRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const HomeworkSummaryItemRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppStyles.font14Regular(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          trailing ??
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.font14Bold(context),
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}

