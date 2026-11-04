import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/models/onboarding_item_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingPageItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.image,
            height: 320.h,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          32.verticalSpace,
          Text(
            item.title,
            style: AppStyles.font24Bold(context),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Text(
            item.description,
            style: AppStyles.font14Regular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

