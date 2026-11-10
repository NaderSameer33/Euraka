import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/helper/helper_method.dart';
import '../../groups/data/models/teacher_group_model.dart';
import '../data/models/create_video_request_body.dart';
import '../data/repos/teacher_lessons_repo.dart';
import 'teacher_add_video_state.dart';

class TeacherAddVideoCubit extends SafeCubit<TeacherAddVideoState> {
  final TeacherLessonsRepo _repo;
  final ImagePicker _imagePicker = ImagePicker();

  final String lessonId;
  final String? breadcrumb;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<TeacherGroupModel> availableGroups = [];
  TeacherGroupModel? selectedGroup;
  String? selectedGroupId;
  File? selectedVideo;

  int _version = 0;

  TeacherAddVideoCubit(
    this._repo, {
    required this.lessonId,
    this.breadcrumb,
  }) : super(const TeacherAddVideoInitialState()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    final res = await _repo.getGroups();
    res.fold(
      (_) {},
      (response) {
        availableGroups = response.data?.groups ?? [];
        if (availableGroups.isNotEmpty) {
          selectedGroup = availableGroups.first;
          selectedGroupId = selectedGroup!.id;
        }
        _emitState();
      },
    );
  }

  void _emitState() {
    _version++;
    emit(TeacherAddVideoLookupsLoadedState(version: _version));
  }

  void selectGroup(TeacherGroupModel group) {
    selectedGroup = group;
    selectedGroupId = group.id;
    _emitState();
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

  Future<bool> submitVideo(BuildContext context) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    if (selectedVideo == null) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى رفع ملف الفيديو',
      );
      return false;
    }

    emit(const TeacherAddVideoSubmittingState());

    final request = CreateVideoRequestBody(
      lessonId: lessonId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      videoFile: selectedVideo!,
      groupId: selectedGroupId,
    );

    final res = await _repo.createVideo(request);

    return res.fold(
      (failure) {
        emit(TeacherAddVideoErrorState(message: failure.message));
        HelperMethod.showErrorToast(context: context, message: failure.message);
        return false;
      },
      (created) {
        emit(const TeacherAddVideoSuccessState(message: 'تم نشر الفيديو بنجاح'));
        HelperMethod.showSuccessToast(context: context, message: 'تم نشر الفيديو بنجاح');
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}

