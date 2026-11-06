import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../data/models/teacher_dashboard_response_model.dart';
import 'teacher_kpi_card.dart';

class TeacherKpiCardsGrid extends StatelessWidget {
  final TeacherKpisModel kpis;

  const TeacherKpiCardsGrid({
    super.key,
    required this.kpis,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TeacherKpiCard(
                icon: SvgPicture.asset(
                  AppAssets.activeExamIcon,
                  width: 26.sp,
                  height: 26.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF3B82F6),
                    BlendMode.srcIn,
                  ),
                ),
                value: '${kpis.activeExamsCount}',
                title: 'امتحانات نشطة',
                growthPercent: kpis.activeExamsGrowthPercent,
                accentColor: const Color(0xFF3B82F6),
                lightBgColor: const Color(0xFFF0F7FF),
                darkBgColor: const Color(0xFF132235),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: TeacherKpiCard(
                icon: Image.asset(
                  AppAssets.studentsIcon,
                  width: 28.sp,
                  height: 28.sp,
                ),
                value: '${kpis.totalStudents}',
                title: 'عدد الطلاب',
                growthPercent: kpis.totalStudentsGrowthPercent,
                accentColor: const Color(0xFF10B981),
                lightBgColor: const Color(0xFFF0FBF5),
                darkBgColor: const Color(0xFF11281E),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: TeacherKpiCard(
                icon: SvgPicture.asset(
                  AppAssets.walletIcon,
                  width: 26.sp,
                  height: 26.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFF59E0B),
                    BlendMode.srcIn,
                  ),
                ),
                value: '${kpis.collectionRatePercentage.toInt()}%',
                title: 'نسبه التحصيل',
                growthPercent: kpis.collectionGrowthPercent,
                accentColor: const Color(0xFFF59E0B),
                lightBgColor: const Color(0xFFFEF9EE),
                darkBgColor: const Color(0xFF2B2110),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: TeacherKpiCard(
                icon: SvgPicture.asset(
                  AppAssets.groupsIcon,
                  width: 26.sp,
                  height: 26.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF8B5CF6),
                    BlendMode.srcIn,
                  ),
                ),
                value: '${kpis.activeGroupsCount}',
                title: 'مجموعات',
                growthPercent: kpis.activeGroupsGrowthPercent,
                accentColor: const Color(0xFF8B5CF6),
                lightBgColor: const Color(0xFFF7F4FD),
                darkBgColor: const Color(0xFF221A35),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
