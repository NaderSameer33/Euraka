import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_styles.dart';

class TeacherGroupsSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? hintText;

  const TeacherGroupsSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20.sp,
            color: colorScheme.onSurfaceVariant,
          ),
          8.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.right,
              style: AppStyles.font14Regular(context),
              decoration: InputDecoration(
                hintText: hintText ?? '...ابحث عن مجموعه',
                hintStyle: AppStyles.font14Regular(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

