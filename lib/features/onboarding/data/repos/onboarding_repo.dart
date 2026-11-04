import '../../../../core/constants/app_assets.dart';
import '../models/onboarding_item_model.dart';

class OnboardingRepo {
  List<OnboardingItemModel> getOnboardingItems() {
    return const [
      OnboardingItemModel(
        image: AppAssets.onboarding1,
        title: 'إدارة المجموعات والطلاب بسهولة',
        description:
            'نظم مجموعاتك الدراسية وتابع حضور وغياب الطلاب وتفاصيل كل مجموعة بدقة وسرعة من مكان واحد.',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding2,
        title: 'إنشاء الواجبات والاختبارات',
        description:
            'صمم اختبارات وواجبات إلكترونية ومقالية مع إمكانية التصحيح التلقائي ورصد الدرجات فورياً.',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding3,
        title: 'متابعة الدخل والتحصيل المالي',
        description:
            'سجل مدفوعات واشتراكات الطلاب لكل حصة ومجموعة وتابع التقارير المالية بكل وضوح.',
      ),
      OnboardingItemModel(
        image: AppAssets.onboarding4,
        title: 'تواصل فوري ومستمر مع الطلاب',
        description:
            'تواصل مع طلابك وأولياء الأمور وأرسل التنبيهات والإشعارات المهمة لضمان أفضل تجربة تعليمية.',
      ),
    ];
  }
}

