import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/helper/helper_method.dart';
import '../../../../core/theme/app_styles.dart';
import '../../groups/data/models/academic_stage_model.dart';
import '../data/models/create_unit_request_body.dart';
import '../data/models/teacher_subject_model.dart';
import '../data/repos/teacher_subjects_repo.dart';
import 'add_unit_state.dart';

class AddUnitCubit extends SafeCubit<AddUnitState> {
  final TeacherSubjectsRepo _repo;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<TeacherSubjectModel> availableSubjects = [];
  List<AcademicStageModel> stages = [];

  TeacherSubjectModel? selectedSubject;
  String? selectedSubjectId;

  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;
  String? selectedGradeLevelId;

  int unitNumber;
  File? coverPhoto;
  List<String> chapters = [
    'فصل 1 : أساسيات الجبر',
    'فصل 2 : المعادلات الجبرية',
  ];

  int _version = 0;

  AddUnitCubit(
    this._repo, {
    String? initialSubjectId,
    String? initialSubjectName,
    String? initialGradeLevelId,
    int? initialUnitNumber,
  })  : selectedSubjectId = initialSubjectId,
        selectedGradeLevelId = initialGradeLevelId,
        unitNumber = initialUnitNumber ?? 1,
        super(const AddUnitInitialState()) {
    loadLookups();
  }

  Future<void> loadLookups() async {
    final stagesRes = await _repo.getStages();
    stagesRes.fold(
      (_) {},
      (response) {
        stages = response.data;
        _resolveInitialGrade();
      },
    );

    final subjectsRes = await _repo.getSubjects();
    subjectsRes.fold(
      (_) {},
      (response) {
        availableSubjects = response.data;
        if (selectedSubjectId != null && selectedSubjectId!.isNotEmpty) {
          try {
            selectedSubject = availableSubjects.firstWhere(
              (s) => s.id == selectedSubjectId,
            );
          } catch (_) {
            if (availableSubjects.isNotEmpty) {
              selectedSubject = availableSubjects.first;
              selectedSubjectId = selectedSubject!.id;
            }
          }
        } else if (availableSubjects.isNotEmpty) {
          selectedSubject = availableSubjects.first;
          selectedSubjectId = selectedSubject!.id;
        }

        if (selectedSubject?.gradeLevelId != null && selectedGradeLevelId == null) {
          selectedGradeLevelId = selectedSubject!.gradeLevelId;
          _resolveInitialGrade();
        }
      },
    );

    _emitState();
  }

  void _resolveInitialGrade() {
    if (stages.isEmpty) return;

    if (selectedGradeLevelId != null && selectedGradeLevelId!.isNotEmpty) {
      for (final stage in stages) {
        for (final grade in stage.grades) {
          if (grade.id == selectedGradeLevelId) {
            selectedStage = stage;
            selectedGrade = grade;
            return;
          }
        }
      }
    }

    if (selectedSubject?.gradeLevelId != null && selectedSubject!.gradeLevelId!.isNotEmpty) {
      for (final stage in stages) {
        for (final grade in stage.grades) {
          if (grade.id == selectedSubject!.gradeLevelId) {
            selectedStage = stage;
            selectedGrade = grade;
            selectedGradeLevelId = grade.id;
            return;
          }
        }
      }
    }

    if (selectedGrade == null && stages.isNotEmpty && stages.first.grades.isNotEmpty) {
      selectedStage = stages.first;
      selectedGrade = stages.first.grades.first;
      selectedGradeLevelId = selectedGrade!.id;
    }
  }

  void _emitState() {
    _version++;
    emit(AddUnitLookupsLoadedState(version: _version));
  }

  void selectSubject(TeacherSubjectModel subject) {
    selectedSubject = subject;
    selectedSubjectId = subject.id;
    if (subject.gradeLevelId != null && subject.gradeLevelId!.isNotEmpty) {
      selectedGradeLevelId = subject.gradeLevelId;
      _resolveInitialGrade();
    }
    _emitState();
  }

  void selectGrade(AcademicStageModel stage, GradeLevelModel grade) {
    selectedStage = stage;
    selectedGrade = grade;
    selectedGradeLevelId = grade.id;
    _emitState();
  }

  void incrementUnitNumber() {
    unitNumber++;
    _emitState();
  }

  void decrementUnitNumber() {
    if (unitNumber > 1) {
      unitNumber--;
      _emitState();
    }
  }

  void addChapter(String title) {
    final trimmed = title.trim();
    if (trimmed.isNotEmpty) {
      chapters.add(trimmed);
      _emitState();
    }
  }

  void editChapter(int index, String newTitle) {
    final trimmed = newTitle.trim();
    if (trimmed.isNotEmpty && index >= 0 && index < chapters.length) {
      chapters[index] = trimmed;
      _emitState();
    }
  }

  void deleteChapter(int index) {
    if (index >= 0 && index < chapters.length) {
      chapters.removeAt(index);
      _emitState();
    }
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
        _emitState();
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
    _emitState();
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

  Future<bool> submitUnit(BuildContext context) async {
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return false;
    }

    final targetSubjectId = selectedSubjectId ?? selectedSubject?.id;
    if (targetSubjectId == null || targetSubjectId.isEmpty) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى اختيار المادة الدراسية',
      );
      return false;
    }

    final targetGradeLevelId = selectedGradeLevelId ??
        selectedGrade?.id ??
        (stages.isNotEmpty && stages.first.grades.isNotEmpty
            ? stages.first.grades.first.id
            : null);

    if (targetGradeLevelId == null || targetGradeLevelId.isEmpty) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'الصف الدراسي مطلوب',
      );
      return false;
    }

    emit(const AddUnitSubmittingState());

    final request = CreateUnitRequestBody(
      subjectId: targetSubjectId,
      gradeLevelId: targetGradeLevelId,
      title: titleController.text.trim(),
      unitNumber: unitNumber,
      description: descriptionController.text.trim(),
      availableSubjectIds: targetSubjectId,
      photoFile: coverPhoto,
      chapters: chapters,
    );

    final result = await _repo.createUnit(request);

    return result.fold(
      (failure) {
        emit(AddUnitErrorState(message: failure.message));
        HelperMethod.showErrorToast(
          context: context,
          message: failure.message,
        );
        return false;
      },
      (created) {
        emit(const AddUnitSuccessState(message: 'تم إضافة الوحدة بنجاح'));
        HelperMethod.showSuccessToast(
          context: context,
          message: 'تم إضافة الوحدة بنجاح',
        );
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
