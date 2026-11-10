import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';

class AddChapterDialog extends StatefulWidget {
  final String? initialText;
  final String title;

  const AddChapterDialog({
    super.key,
    this.initialText,
    this.title = 'إضافة فصل جديد',
  });

  static Future<String?> show({
    required BuildContext context,
    String? initialText,
    String title = 'إضافة فصل جديد',
  }) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AddChapterDialog(
        initialText: initialText,
        title: title,
      ),
    );
  }

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: AppStyles.font18Bold(context),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            AppInput(
              controller: _controller,
              hintText: 'مثال: فصل 1 : أساسيات الجبر',
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'حفظ',
                    height: 44.h,
                    onPressed: () {
                      final val = _controller.text.trim();
                      if (val.isNotEmpty) {
                        Navigator.of(context).pop(val);
                      }
                    },
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: AppButton(
                    text: 'إلغاء',
                    height: 44.h,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    textStyle: AppStyles.font14Medium(context),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
