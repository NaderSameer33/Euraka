import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../groups/data/models/teacher_group_model.dart';
import '../data/repos/teacher_lessons_repo.dart';
import 'teacher_add_material_state.dart';

class TeacherAddMaterialCubit extends Cubit<TeacherAddMaterialState> {
  final TeacherLessonsRepo _repo;
  final String lessonId;
  final String? breadcrumb;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<TeacherGroupModel> groups = [];
  TeacherGroupModel? selectedGroup;

  String? selectedFilePath;
  String? selectedFileName;
  int selectedFileSizeBytes = 0;

  TeacherAddMaterialCubit(
    this._repo, {
    required this.lessonId,
    this.breadcrumb,
  }) : super(const TeacherAddMaterialInitialState()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    emit(const TeacherAddMaterialGroupsLoadingState());
    final result = await _repo.getGroups();
    result.fold(
      (failure) {
        emit(const TeacherAddMaterialGroupsLoadedState([]));
      },
      (response) {
        groups = response.data?.groups ?? [];
        if (groups.isNotEmpty) {
          selectedGroup = groups.first;
        }
        emit(TeacherAddMaterialGroupsLoadedState(groups));
      },
    );
  }

  void selectGroup(TeacherGroupModel group) {
    selectedGroup = group;
    emit(TeacherAddMaterialGroupsLoadedState(List.from(groups)));
  }

  Future<void> pickMaterialFile() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (file != null && file.path != null) {
        selectedFilePath = file.path;
        selectedFileName = file.name;
        selectedFileSizeBytes = file.lengthSync() ?? 0;

        if (titleController.text.trim().isEmpty) {
          final dotIdx = file.name.lastIndexOf('.');
          final baseName = dotIdx != -1 ? file.name.substring(0, dotIdx) : file.name;
          titleController.text = baseName;
        }

        emit(TeacherAddMaterialFileSelectedState(
          filePath: file.path!,
          fileName: file.name,
          fileSizeBytes: selectedFileSizeBytes,
        ));
      }
    } catch (_) {}
  }

  void removeMaterialFile() {
    selectedFilePath = null;
    selectedFileName = null;
    selectedFileSizeBytes = 0;
    emit(TeacherAddMaterialGroupsLoadedState(List.from(groups)));
  }

  Future<void> submitMaterial() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedFilePath == null) {
      emit(const TeacherAddMaterialErrorState('يرجى اختيار ملف الشرح أولاً'));
      return;
    }

    emit(const TeacherAddMaterialSubmittingState());

    final result = await _repo.createMaterial(
      lessonId: lessonId,
      title: titleController.text.trim(),
      filePath: selectedFilePath!,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      groupId: selectedGroup?.id,
    );

    result.fold(
      (failure) => emit(TeacherAddMaterialErrorState(failure.message)),
      (material) => emit(TeacherAddMaterialSuccessState(material)),
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
