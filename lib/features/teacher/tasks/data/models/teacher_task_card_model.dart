import 'package:flutter/material.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';

enum TaskCategoryType {
  all('الكل'),
  homework('الواجب'),
  exams('الامتحانات'),
  attendance('الغياب');

  final String title;
  const TaskCategoryType(this.title);
}

class TeacherTaskCardModel {
  final String id;
  final String title;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final IconData badgeIcon;
  final Color badgeColor;
  final Color lightBackgroundColor;
  final String imageAsset;
  final TaskCategoryType category;

  const TeacherTaskCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.badgeIcon,
    required this.badgeColor,
    required this.lightBackgroundColor,
    required this.imageAsset,
    required this.category,
  });

  static List<TeacherTaskCardModel> getTasks() {
    return const [
      TeacherTaskCardModel(
        id: 'exams',
        title: 'الامتحانات والاختبارات',
        description: 'انشاء الاختبارات الالكترونيه ومراجعه النتائج وتحليل الاداء',
        buttonText: 'اداره الامتحانات',
        buttonColor: AppColors.primary,
        badgeIcon: Icons.description_outlined,
        badgeColor: AppColors.primary,
        lightBackgroundColor: Color(0xFFF6FBF7),
        imageAsset: AppAssets.examImage,
        category: TaskCategoryType.exams,
      ),
      TeacherTaskCardModel(
        id: 'homework',
        title: 'الواجبات المدرسيه',
        description: 'انشاء واداره الواجبات اليوميه ومتابعه تسليم الطلاب',
        buttonText: 'اداره الواجبات',
        buttonColor: Color(0xFF7B61FF),
        badgeIcon: Icons.assignment_ind_outlined,
        badgeColor: Color(0xFF7B61FF),
        lightBackgroundColor: Color(0xFFF7F4FE),
        imageAsset: AppAssets.homeworkImage,
        category: TaskCategoryType.homework,
      ),
      TeacherTaskCardModel(
        id: 'attendance',
        title: 'الحضور والغياب',
        description: 'تسجيل ومتابعه حضور الطلاب في الحصص اليوميه',
        buttonText: 'اداره الغياب',
        buttonColor: Color(0xFFD97706),
        badgeIcon: Icons.edit_calendar_outlined,
        badgeColor: Color(0xFFD97706),
        lightBackgroundColor: Color(0xFFFFFDF2),
        imageAsset: AppAssets.hadoorImage,
        category: TaskCategoryType.attendance,
      ),
      TeacherTaskCardModel(
        id: 'messaging',
        title: 'التواصل والمتابعه',
        description: 'تواصل مع كل الطلاب وتابع تقدمهم في الدراسه',
        buttonText: 'اداره الاخبار',
        buttonColor: Color(0xFF1E88E5),
        badgeIcon: Icons.near_me_outlined,
        badgeColor: Color(0xFF1E88E5),
        lightBackgroundColor: Color(0xFFF2F8FE),
        imageAsset: AppAssets.messagingImage,
        category: TaskCategoryType.all,
      ),
    ];
  }
}

