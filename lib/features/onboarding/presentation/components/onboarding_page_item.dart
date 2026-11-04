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
          Flexible(
            child: Image.asset(
              item.image,
              height: 280.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          24.verticalSpace,
          Text(
            item.title,
            style: AppStyles.font24Bold(context),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            item.description,
            style: AppStyles.font18Regular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
