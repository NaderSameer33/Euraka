import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/homework_question_model.dart';

class HomeworkQuestionEssayCard extends StatelessWidget {
  final int index;
  final HomeworkQuestionModel question;
  final VoidCallback onDelete;
  final Function(String) onQuestionChanged;
  final Function(String) onModelAnswerChanged;

  const HomeworkQuestionEssayCard({
    super.key,
    required this.index,
    required this.question,
    required this.onDelete,
    required this.onQuestionChanged,
    required this.onModelAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'سؤال ${index + 1} ',
                  style: AppStyles.font16Bold(context),
                  children: [
                    TextSpan(
                      text: '*',
                      style: AppStyles.font16Bold(context).copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: SvgPicture.asset(
                        AppAssets.trashIcon,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.redAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Padding(
                    padding: EdgeInsets.all(6.w),
                    child: SvgPicture.asset(
                      AppAssets.editIcon,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurface.withValues(alpha: 0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          TextFormField(
            initialValue: question.questionText,
            onChanged: onQuestionChanged,
            style: AppStyles.font14Medium(context),
            decoration: InputDecoration(
              hintText: 'اكتب نص السؤال المقالي هنا...',
              hintStyle: AppStyles.font14Regular(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            ),
          ),
          16.verticalSpace,
          RichText(
            text: TextSpan(
              text: 'الاجابه النموذجيه ',
              style: AppStyles.font14Medium(context),
              children: [
                TextSpan(
                  text: '*',
                  style: AppStyles.font14Medium(context).copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          8.verticalSpace,
          TextFormField(
            initialValue: question.modelAnswer,
            onChanged: onModelAnswerChanged,
            maxLines: 4,
            style: AppStyles.font14Medium(context),
            decoration: InputDecoration(
              hintText: 'اكتب نموذج الإجابة لتسهيل التصحيح اليدوي...',
              hintStyle: AppStyles.font13Regular(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}

