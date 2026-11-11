import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/homework_question_model.dart';

class HomeworkDetailsQuestionCard extends StatelessWidget {
  final int index;
  final HomeworkQuestionModel question;
  final bool isCorrect;
  final String? studentAnswer;

  const HomeworkDetailsQuestionCard({
    super.key,
    required this.index,
    required this.question,
    this.isCorrect = true,
    this.studentAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final correctOptionText = question.isMcq &&
            question.options.isNotEmpty &&
            question.correctOptionIndex >= 0 &&
            question.correctOptionIndex < question.options.length
        ? question.options[question.correctOptionIndex]
        : (question.modelAnswer ?? '');

    final cardAccentColor = isCorrect ? AppColors.primary : Colors.redAccent;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4.w,
                color: cardAccentColor,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: cardAccentColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${question.order > 0 ? question.order : index + 1}',
                            style: AppStyles.font14Bold(context).copyWith(
                              color: cardAccentColor,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: AppStyles.font14Bold(context),
                            ),
                            8.verticalSpace,
                            if (studentAnswer != null && studentAnswer!.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                    color: cardAccentColor,
                                    size: 16.r,
                                  ),
                                  6.horizontalSpace,
                                  Text(
                                    'إجابتك: $studentAnswer',
                                    style: AppStyles.font12Medium(context).copyWith(
                                      color: cardAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                              4.verticalSpace,
                            ],
                            if (!isCorrect && correctOptionText.isNotEmpty) ...[
                              Text(
                                'الإجابة الصحيحة: $correctOptionText',
                                style: AppStyles.font12Medium(context).copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ] else if (isCorrect && studentAnswer == null && correctOptionText.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 16.r,
                                  ),
                                  6.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      question.isMcq
                                          ? 'الإجابة الصحيحة: $correctOptionText'
                                          : 'الإجابة النموذجية: $correctOptionText',
                                      style: AppStyles.font12Medium(context).copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
