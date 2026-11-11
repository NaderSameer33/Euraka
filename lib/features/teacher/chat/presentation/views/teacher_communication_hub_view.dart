import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/helper/helper_method.dart';

enum CommunicationOption {
  chatWithStudents,
  sendNotification,
}

class TeacherCommunicationHubView extends StatefulWidget {
  const TeacherCommunicationHubView({super.key});

  @override
  State<TeacherCommunicationHubView> createState() => _TeacherCommunicationHubViewState();
}

class _TeacherCommunicationHubViewState extends State<TeacherCommunicationHubView> {
  CommunicationOption? _selectedOption;

  void _onContinue() {
    if (_selectedOption == null) return;

    if (_selectedOption == CommunicationOption.chatWithStudents) {
      context.push(AppRouterName.teacherInbox);
    } else {
      HelperMethod.showInfoToast(
        context: context,
        message: 'خدمة إرسال الإشعارات الجماعية ستتوفر قريباً',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onSurface,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          title: Text(
            'التواصل',
            style: AppStyles.font18Bold(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOptionCard(
                  context: context,
                  option: CommunicationOption.chatWithStudents,
                  title: 'محادثة مع الطلاب',
                  description: 'ابدأ محادثة فردية مع الطلاب بسهولة',
                  imageAsset: AppAssets.chatImage,
                  isSelected: _selectedOption == CommunicationOption.chatWithStudents,
                ),
                16.verticalSpace,
                _buildOptionCard(
                  context: context,
                  option: CommunicationOption.sendNotification,
                  title: 'ارسال اشعار',
                  description: 'ارسل رساله او اعلان لكل الطلاب او مجموعه',
                  imageAsset: AppAssets.notificationMegaphoneImage,
                  isSelected: _selectedOption == CommunicationOption.sendNotification,
                ),
                const Spacer(),
                if (_selectedOption != null)
                  AppButton(
                    text: 'التالي',
                    onPressed: _onContinue,
                  ),
                12.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required CommunicationOption option,
    required String title,
    required String description,
    required String imageAsset,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : colorScheme.outline.withValues(alpha: 0.15),
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  imageAsset,
                  width: 42.w,
                  height: 42.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    option == CommunicationOption.chatWithStudents
                        ? Icons.chat_bubble_outline_rounded
                        : Icons.campaign_outlined,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.font16Bold(context).copyWith(
                      color: isSelected ? AppColors.primary : colorScheme.onSurface,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    description,
                    style: AppStyles.font12Regular(context).copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            12.horizontalSpace,
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : colorScheme.outline.withValues(alpha: 0.4),
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
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
}
