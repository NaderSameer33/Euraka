import '../../../../core/constants/app_assets.dart';
import '../models/onboarding_item_model.dart';

class OnboardingRepo {
  List<OnboardingItemModel> getOnboardingItems() {
    return const [
      OnboardingItemModel(
        image: AppAssets.onboarding1,
        title: 'تعلم بذكاء ، ليس بجهد',
        description:
            'منصه تعليميه تجمع الطلاب والمدرسين في تجربه ذكيه وسهله',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding4,
        title: 'كل شئ في مكان واحد',
        description:
            'فيديوهات ملفات واجبات ... كل حاجه منظمه وسهله الوصول',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding2,
        title: 'ابق علي تواصل دائما',
        description:
            'تواصل مباشر بين الطالب والمدرس + اشعارات فوريه كلا الطرفين',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding3,
        title: 'جاهز للبدأ',
        description:
            'منهجك، أدواتك، وكل ما تحتاجه كطالب.. متاح في مكان واحد',
      ),
    ];
  }
}
