import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/helper/helper_method.dart';
import '../../subjects/data/models/subject_unit_model.dart';
import '../../subjects/data/models/teacher_subject_model.dart';
import '../data/models/create_lesson_request_body.dart';
import '../data/repos/teacher_lessons_repo.dart';
import 'teacher_add_lesson_state.dart';

class TeacherAddLessonCubit extends SafeCubit<TeacherAddLessonState> {
  final TeacherLessonsRepo _repo;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<TeacherSubjectModel> availableSubjects = [];
  List<SubjectUnitModel> availableUnits = [];

  TeacherSubjectModel? selectedSubject;
  SubjectUnitModel? selectedUnit;
  String? selectedSubjectId;
  String? selectedUnitId;

  int lessonOrder;
  File? selectedVideo;
  List<File> attachments = [];

  int _version = 0;

  TeacherAddLessonCubit(
    this._repo, {
    String? initialSubjectId,
    String? initialUnitId,
    int? initialLessonOrder,
  })  : selectedSubjectId = initialSubjectId,
        selectedUnitId = initialUnitId,
        lessonOrder = initialLessonOrder ?? 1,
        super(const TeacherAddLessonInitialState()) {
    loadLookups();
  }

  Future<void> loadLookups() async {
    final subRes = await _repo.getSubjects();
    subRes.fold(
      (_) {},
      (response) {
        availableSubjects = response.data;
        if (selectedSubjectId != null && selectedSubjectId!.isNotEmpty) {
          try {
            selectedSubject = availableSubjects.firstWhere((s) => s.id == selectedSubjectId);
          } catch (_) {
            if (availableSubjects.isNotEmpty) selectedSubject = availableSubjects.first;
          }
        } else if (availableSubjects.isNotEmpty) {
          selectedSubject = availableSubjects.first;
          selectedSubjectId = selectedSubject!.id;
        }
      },
    );

    if (selectedSubjectId != null && selectedSubjectId!.isNotEmpty) {
      await loadUnitsForSubject(selectedSubjectId!);
    } else {
      _emitState();
    }
  }

  Future<void> loadUnitsForSubject(String subjectId) async {
    final unitsRes = await _repo.getSubjectUnits(subjectId);
    unitsRes.fold(
      (_) {},
      (response) {
        availableUnits = response.data?.units ?? [];
        if (selectedUnitId != null && selectedUnitId!.isNotEmpty) {
          try {
            selectedUnit = availableUnits.firstWhere((u) => u.id == selectedUnitId);
          } catch (_) {
            if (availableUnits.isNotEmpty) selectedUnit = availableUnits.first;
          }
        } else if (availableUnits.isNotEmpty) {
          selectedUnit = availableUnits.first;
          selectedUnitId = selectedUnit!.id;
        }
      },
    );
    _emitState();
  }

  void _emitState() {
    _version++;
    emit(TeacherAddLessonLookupsLoadedState(version: _version));
  }

  void selectSubject(TeacherSubjectModel subject) {
    selectedSubject = subject;
    selectedSubjectId = subject.id;
    selectedUnit = null;
    selectedUnitId = null;
    loadUnitsForSubject(subject.id);
  }

  void selectUnit(SubjectUnitModel unit) {
    selectedUnit = unit;
    selectedUnitId = unit.id;
    _emitState();
  }

  void incrementOrder() {
    lessonOrder++;
    _emitState();
  }

  void decrementOrder() {
    if (lessonOrder > 1) {
      lessonOrder--;
      _emitState();
    }
  }

  Future<void> pickVideo(BuildContext context) async {
    try {
      final picked = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (picked != null) {
        selectedVideo = File(picked.path);
        _emitState();
      }
    } catch (_) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر اختيار الفيديو، يرجى مراجعة الصلاحيات',
        );
      }
    }
  }

  void removeVideo() {
    selectedVideo = null;
    _emitState();
  }

  Future<void> pickAttachments() async {
    try {
      final files = await FilePicker.pickFiles();
      if (files.isNotEmpty) {
        for (final f in files) {
          if (f.path != null) {
            attachments.add(File(f.path!));
          }
        }
        _emitState();
      }
    } catch (_) {}
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
      _emitState();
    }
  }

  Future<bool> submitLesson(BuildContext context) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    final targetSubjectId = selectedSubjectId ?? selectedSubject?.id;
    final targetUnitId = selectedUnitId ?? selectedUnit?.id;

    if (targetSubjectId == null || targetSubjectId.isEmpty) {
      HelperMethod.showErrorToast(context: context, message: 'يرجى اختيار المادة');
      return false;
    }

    if (targetUnitId == null || targetUnitId.isEmpty) {
      HelperMethod.showErrorToast(context: context, message: 'يرجى اختيار الوحدة');
      return false;
    }

    emit(const TeacherAddLessonSubmittingState());

    final lessonName = nameController.text.trim().isNotEmpty
        ? nameController.text.trim()
        : titleController.text.trim();

    final request = CreateLessonRequestBody(
      subjectId: targetSubjectId,
      unitId: targetUnitId,
      name: lessonName,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      lessonOrder: lessonOrder,
      videoFile: selectedVideo,
      attachmentFiles: attachments,
    );

    final res = await _repo.createLesson(request);

    return res.fold(
      (failure) {
        emit(TeacherAddLessonErrorState(message: failure.message));
        HelperMethod.showErrorToast(context: context, message: failure.message);
        return false;
      },
      (created) {
        emit(const TeacherAddLessonSuccessState(message: 'تم إضافة الدرس بنجاح'));
        HelperMethod.showSuccessToast(context: context, message: 'تم إضافة الدرس بنجاح');
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
