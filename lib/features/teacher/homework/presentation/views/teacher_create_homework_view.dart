import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_assets.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../groups/presentation/components/select_grade_bottom_sheet.dart';
import '../../logic/create_homework_cubit.dart';
import '../../logic/create_homework_state.dart';
import '../components/create_homework_header_card.dart';
import '../components/homework_date_picker_bottom_sheet.dart';
import '../components/homework_question_essay_card.dart';
import '../components/homework_question_mcq_card.dart';
import '../components/homework_summary_item_row.dart';
import '../components/homework_type_selector_card.dart';

class TeacherCreateHomeworkView extends StatefulWidget {
  const TeacherCreateHomeworkView({super.key});

  @override
  State<TeacherCreateHomeworkView> createState() => _TeacherCreateHomeworkViewState();
}

class _TeacherCreateHomeworkViewState extends State<TeacherCreateHomeworkView> {
  late final TextEditingController _teacherNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _teacherNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleController = TextEditingController();

    context.read<CreateHomeworkCubit>().fetchInitialData();
  }

  @override
  void dispose() {
    _teacherNameController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  String _getStepTitle(CreateHomeworkState state) {
    switch (state.step) {
      case 0:
        return 'اضافه واجب جديد';
      case 1:
        return 'انشاء واجب جديد';
      case 2:
        return state.isMcq ? 'الواجب الاختياري' : 'الواجب المقالي';
      case 3:
        return 'تحديد موعد التسليم';
      case 4:
        return 'نشر الواجب';
      default:
        return 'اضافه واجب جديد';
    }
  }

  void _onBackPressed(BuildContext context, CreateHomeworkCubit cubit, CreateHomeworkState state) {
    if (state.step > 0) {
      cubit.previousStep();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<CreateHomeworkCubit>();

    return BlocConsumer<CreateHomeworkCubit, CreateHomeworkState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          HelperMethod.showErrorToast(
            context: context,
            message: state.errorMessage!,
          );
        }
        if (state.isSuccess) {
          HelperMethod.showSuccessToast(
            context: context,
            message: 'تم إنشاء ونشر الواجب بنجاح',
          );
          context.pop();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state.step == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && state.step > 0) {
              cubit.previousStep();
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => _onBackPressed(context, cubit, state),
                        borderRadius: BorderRadius.circular(22.r),
                        child: Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20.r,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        _getStepTitle(state),
                        style: AppStyles.font18Bold(context),
                      ),
                      SizedBox(width: 44.r),
                    ],
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildCurrentStep(context, cubit, state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    switch (state.step) {
      case 0:
        return _buildStep1BasicInfo(context, cubit, state);
      case 1:
        return _buildStep2TypeSelection(context, cubit, state);
      case 2:
        return _buildStep3Questions(context, cubit, state);
      case 3:
        return _buildStep4DueDate(context, cubit, state);
      case 4:
        return _buildStep5SummaryPublish(context, cubit, state);
      default:
        return _buildStep1BasicInfo(context, cubit, state);
    }
  }

  Widget _buildFieldLabel(BuildContext context, String text, {bool isRequired = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: isRequired ? '* ' : '',
          style: AppStyles.font14Medium(context).copyWith(
            color: Colors.redAccent,
          ),
          children: [
            TextSpan(
              text: text,
              style: AppStyles.font14Medium(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1BasicInfo(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel(context, 'اختر الصف الدراسي'),
          InkWell(
            onTap: () {
              if (state.stages.isNotEmpty) {
                SelectGradeBottomSheet.show(
                  context: context,
                  stages: state.stages,
                  selectedGrade: state.selectedGrade,
                  onSelected: (stage, grade) {
                    cubit.setGrade(grade);
                  },
                );
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.selectedGrade?.nameAr ?? 'اختر الصف',
                    style: AppStyles.font14Medium(context).copyWith(
                      color: state.selectedGrade == null
                          ? colorScheme.onSurface.withValues(alpha: 0.4)
                          : colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
          16.verticalSpace,
          _buildFieldLabel(context, 'اسم المجموعه'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.selectedGroupId,
                hint: Text(
                  'اختر المجموعة',
                  style: AppStyles.font14Regular(context).copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                dropdownColor: colorScheme.surface,
                items: state.groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group.id,
                    child: Text(
                      group.name,
                      style: AppStyles.font14Medium(context),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final grp = state.groups.firstWhere((g) => g.id == val);
                    cubit.setGroup(grp.id, grp.name);
                  }
                },
              ),
            ),
          ),
          16.verticalSpace,
          _buildFieldLabel(context, 'اختر الماده'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.selectedSubjectId,
                hint: Text(
                  'اختر المادة',
                  style: AppStyles.font14Regular(context).copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                dropdownColor: colorScheme.surface,
                items: state.subjects.map((sub) {
                  return DropdownMenuItem<String>(
                    value: sub.id,
                    child: Text(
                      sub.nameAr,
                      style: AppStyles.font14Medium(context),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final s = state.subjects.firstWhere((item) => item.id == val);
                    cubit.setSubject(s.id, s.nameAr);
                  }
                },
              ),
            ),
          ),
          16.verticalSpace,
          _buildFieldLabel(context, 'اسم المدرس'),
          TextFormField(
            controller: _teacherNameController,
            onChanged: cubit.setTeacherName,
            style: AppStyles.font14Medium(context),
            decoration: InputDecoration(
              hintText: 'محمد احمد',
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
          _buildFieldLabel(context, 'وصف الواجب', isRequired: false),
          TextFormField(
            controller: _descriptionController,
            onChanged: cubit.setDescription,
            maxLines: 4,
            style: AppStyles.font14Medium(context),
            decoration: InputDecoration(
              hintText: 'اختياري',
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
          32.verticalSpace,
          ElevatedButton(
            onPressed: () {
              cubit.nextStep(
                onError: (err) => HelperMethod.showErrorToast(context: context, message: err),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'التالي',
              style: AppStyles.font16Bold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildStep2TypeSelection(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel(context, 'اسم الواجب'),
          TextFormField(
            controller: _titleController,
            onChanged: cubit.setTitle,
            style: AppStyles.font14Medium(context),
            decoration: InputDecoration(
              hintText: 'واجب المعادلات - الجزء الاول',
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
          24.verticalSpace,
          HomeworkTypeSelectorCard(
            title: 'اختيار من متعدد (MCQ)',
            subtitle: 'اسئله باجابات محدده وتصحيح تلقائي',
            badgeText: 'لأسئلة التفكير والتحليل',
            imagePath: AppAssets.mcqImage,
            isSelected: state.isMcq,
            onTap: () => cubit.setHomeworkType('MCQ'),
          ),
          16.verticalSpace,
          HomeworkTypeSelectorCard(
            title: 'إجابة مقالية (Essay)',
            subtitle: 'اجابات مفتوحه تحتاج تصحيح يدوي',
            badgeText: 'يوصى به للاختبارات السريعة',
            imagePath: AppAssets.maqulyImage,
            isSelected: !state.isMcq,
            onTap: () => cubit.setHomeworkType('ESSAY'),
          ),
          36.verticalSpace,
          ElevatedButton(
            onPressed: () {
              cubit.nextStep(
                onError: (err) => HelperMethod.showErrorToast(context: context, message: err),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'التالي',
              style: AppStyles.font16Bold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildStep3Questions(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CreateHomeworkHeaderCard(
            title: state.title.trim().isNotEmpty ? state.title : 'واجب بدون عنوان',
            questionsCount: state.questions.length,
            durationMinutes: state.durationMinutes,
            totalScore: state.totalScore,
          ),
          16.verticalSpace,
          ...List.generate(state.questions.length, (idx) {
            final q = state.questions[idx];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: state.isMcq
                  ? HomeworkQuestionMcqCard(
                      index: idx,
                      question: q,
                      onDelete: () => cubit.removeQuestion(idx),
                      onQuestionChanged: (val) => cubit.updateQuestionText(idx, val),
                      onOptionChanged: (optIdx, val) => cubit.updateOptionText(idx, optIdx, val),
                      onCorrectOptionSelected: (optIdx) => cubit.setCorrectOption(idx, optIdx),
                    )
                  : HomeworkQuestionEssayCard(
                      index: idx,
                      question: q,
                      onDelete: () => cubit.removeQuestion(idx),
                      onQuestionChanged: (val) => cubit.updateQuestionText(idx, val),
                      onModelAnswerChanged: (val) => cubit.updateModelAnswer(idx, val),
                    ),
            );
          }),
          OutlinedButton(
            onPressed: cubit.addQuestion,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'اضافه سؤال جديد',
              style: AppStyles.font16Bold(context).copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          12.verticalSpace,
          ElevatedButton(
            onPressed: () {
              cubit.nextStep(
                onError: (err) => HelperMethod.showErrorToast(context: context, message: err),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'التالي',
              style: AppStyles.font16Bold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildStep4DueDate(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
                _buildFieldLabel(context, 'التاريخ والوقت'),
                8.verticalSpace,
                InkWell(
                  onTap: () {
                    HomeworkDatePickerBottomSheet.show(
                      context: context,
                      initialDate: state.dueDate,
                      onDateConfirmed: cubit.setDueDate,
                    );
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            ArabicDateHelper.formatFull(state.dueDate),
                            style: AppStyles.font14Medium(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20.r,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Container(
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
                _buildFieldLabel(context, 'اغلاق الواجب بعد الموعد'),
                12.verticalSpace,
                _buildCloseOptionTile(
                  context: context,
                  title: 'نعم اغلاق تلقائيا',
                  isSelected: state.autoCloseAfterDue,
                  onTap: () => cubit.setAutoCloseAfterDue(true),
                ),
                10.verticalSpace,
                _buildCloseOptionTile(
                  context: context,
                  title: 'لا السماح بالتأخير',
                  isSelected: !state.autoCloseAfterDue,
                  onTap: () => cubit.setAutoCloseAfterDue(false),
                ),
              ],
            ),
          ),
          36.verticalSpace,
          ElevatedButton(
            onPressed: () {
              cubit.nextStep(
                onError: (err) => HelperMethod.showErrorToast(context: context, message: err),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'التالي',
              style: AppStyles.font16Bold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildCloseOptionTile({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.font14Medium(context),
            ),
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : colorScheme.outline.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5SummaryPublish(
    BuildContext context,
    CreateHomeworkCubit cubit,
    CreateHomeworkState state,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final typeDescription = state.isMcq
        ? 'اختيار من متعدد (${state.questions.length} أسئلة)'
        : 'إجابة مقالية (${state.questions.length} أسئلة)';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          12.verticalSpace,
          Center(
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: Center(
                child: Container(
                  width: 54.r,
                  height: 54.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 32.r,
                  ),
                ),
              ),
            ),
          ),
          12.verticalSpace,
          Text(
            'تفاصيل الواجب الجاهز للنشر',
            style: AppStyles.font16Bold(context),
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                HomeworkSummaryItemRow(
                  label: 'اسم الواجب',
                  value: state.title.trim().isNotEmpty ? state.title : 'واجب جديد',
                ),
                Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
                HomeworkSummaryItemRow(
                  label: 'نوع الواجب',
                  value: typeDescription,
                ),
                Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
                HomeworkSummaryItemRow(
                  label: 'إجمالي الدرجات',
                  value: '${state.totalScore} درجة',
                ),
                Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
                HomeworkSummaryItemRow(
                  label: 'موعد التسليم',
                  value: ArabicDateHelper.formatFull(state.dueDate),
                ),
                Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
                HomeworkSummaryItemRow(
                  label: 'حالة الإغلاق',
                  value: state.autoCloseAfterDue ? 'إغلاق تلقائي بعد الموعد' : 'السماح بالتأخير',
                ),
              ],
            ),
          ),
          16.verticalSpace,
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFFFFA000),
                  size: 22,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'سيتم إرسال إشعار لجميع طلاب المجموعة فور نشر الواجب للتنبيه بموعد التسليم',
                    style: AppStyles.font12Medium(context).copyWith(
                      color: const Color(0xFF8D6E63),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          32.verticalSpace,
          ElevatedButton(
            onPressed: state.isLoading ? null : cubit.publishHomework,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: state.isLoading
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'نشر الواجب',
                    style: AppStyles.font16Bold(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
