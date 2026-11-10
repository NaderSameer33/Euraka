import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/helper/helper_method.dart';
import '../../../../core/theme/app_styles.dart';
import '../../groups/data/models/academic_stage_model.dart';
import '../../groups/data/models/teacher_group_model.dart';
import '../data/models/create_subject_request_body.dart';
import '../data/repos/teacher_subjects_repo.dart';
import 'add_subject_state.dart';

class AddSubjectCubit extends SafeCubit<AddSubjectState> {
  final TeacherSubjectsRepo _repo;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nameEnController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<AcademicStageModel> stages = [];
  List<TeacherGroupModel> allGroups = [];
  List<TeacherGroupModel> selectedGroups = [];

  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;
  File? coverPhoto;
  List<String> chapters = [
    'فصل 1 : أساسيات الجبر',
    'فصل 2 : المعادلات الجبرية',
  ];

  int _version = 0;

  AddSubjectCubit(this._repo) : super(const AddSubjectInitialState()) {
    loadLookups();
  }

  List<TeacherGroupModel> get availableGroupsForGrade {
    if (selectedGrade == null) {
      return allGroups;
    }
    final gradeName = selectedGrade!.nameAr.trim().toLowerCase();
    final filtered = allGroups.where((group) {
      final groupGrade = group.gradeLevelName.trim().toLowerCase();
      return groupGrade.isNotEmpty && (groupGrade == gradeName || gradeName.contains(groupGrade));
    }).toList();

    return filtered.isNotEmpty ? filtered : allGroups;
  }

  Future<void> loadLookups() async {
    final stagesRes = await _repo.getStages();
    stagesRes.fold(
      (_) {},
      (response) {
        stages = response.data;
      },
    );

    final groupsRes = await _repo.getGroups();
    groupsRes.fold(
      (_) {},
      (response) {
        allGroups = response.data?.groups ?? [];
      },
    );

    _emitLookups();
  }

  void _emitLookups() {
    _version++;
    emit(AddSubjectLookupsLoadedState(version: _version));
  }

  void selectGrade(AcademicStageModel stage, GradeLevelModel grade) {
    selectedStage = stage;
    selectedGrade = grade;
    selectedGroups.clear();
    _emitLookups();
  }

  void setSelectedGroups(List<TeacherGroupModel> groups) {
    selectedGroups = List.from(groups);
    _emitLookups();
  }

  void toggleGroupSelection(TeacherGroupModel group) {
    final exists = selectedGroups.any((g) => g.id == group.id);
    if (exists) {
      selectedGroups.removeWhere((g) => g.id == group.id);
    } else {
      selectedGroups.add(group);
    }
    _emitLookups();
  }

  void removeGroup(TeacherGroupModel group) {
    selectedGroups.removeWhere((g) => g.id == group.id);
    _emitLookups();
  }

  Future<void> pickCoverPhoto(BuildContext context) async {
    final source = await _selectImageSource(context);
    if (source == null) return;

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        coverPhoto = File(picked.path);
        _emitLookups();
      }
    } catch (_) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر فتح الصور، يرجى التحقق من الأذونات',
        );
      }
    }
  }

  void removeCoverPhoto() {
    coverPhoto = null;
    _emitLookups();
  }

  void addChapter(String title) {
    final trimmed = title.trim();
    if (trimmed.isNotEmpty) {
      chapters.add(trimmed);
      _emitLookups();
    }
  }

  void editChapter(int index, String newTitle) {
    final trimmed = newTitle.trim();
    if (trimmed.isNotEmpty && index >= 0 && index < chapters.length) {
      chapters[index] = trimmed;
      _emitLookups();
    }
  }

  void deleteChapter(int index) {
    if (index >= 0 && index < chapters.length) {
      chapters.removeAt(index);
      _emitLookups();
    }
  }

  Future<ImageSource?> _selectImageSource(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                16.verticalSpace,
                Text(
                  'اختيار مصدر الصورة',
                  style: AppStyles.font18Bold(ctx),
                ),
                16.verticalSpace,
                ListTile(
                  leading: Icon(Icons.photo_library_rounded, color: colorScheme.primary),
                  title: Text('المعرض', style: AppStyles.font16Medium(ctx)),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded, color: colorScheme.primary),
                  title: Text('الكاميرا', style: AppStyles.font16Medium(ctx)),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> submitSubject(BuildContext context) async {
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return false;
    }

    if (selectedGrade == null) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى اختيار الصف الدراسي',
      );
      return false;
    }

    if (coverPhoto == null) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى اختيار صورة الغلاف',
      );
      return false;
    }

    emit(const AddSubjectLoadingState());

    final body = CreateSubjectRequestBody(
      name: nameController.text.trim(),
      nameAr: nameController.text.trim(),
      nameEn: nameEnController.text.trim().isNotEmpty
          ? nameEnController.text.trim()
          : null,
      gradeLevelId: selectedGrade!.id,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : 'مادة دراسية',
      groupIds: selectedGroups.map((g) => g.id).toList(),
      photo: coverPhoto,
      chapters: chapters,
    );

    final res = await _repo.createSubject(body);

    return res.fold(
      (failure) {
        emit(AddSubjectErrorState(message: failure.message));
        HelperMethod.showErrorToast(
          context: context,
          message: failure.message,
        );
        return false;
      },
      (responseModel) {
        emit(AddSubjectSuccessState(createdSubject: responseModel.data));
        HelperMethod.showSuccessToast(
          context: context,
          message: responseModel.message.isNotEmpty
              ? responseModel.message
              : 'تمت إضافة المادة بنجاح',
        );
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    nameEnController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
