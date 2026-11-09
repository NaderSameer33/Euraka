import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/edit_student_request_body.dart';
import '../data/models/teacher_group_model.dart';
import '../data/models/teacher_student_details_model.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'teacher_edit_student_state.dart';

class TeacherEditStudentCubit extends SafeCubit<TeacherEditStudentState> {
  final TeacherGroupsRepo _repo;
  final String studentId;
  final TeacherStudentDetailsData? initialData;
  final String? initialGroupId;
  final String? initialGroupName;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();

  File? avatarFile;
  String? avatarUrl;

  List<AcademicStageModel> stages = [];
  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;

  List<TeacherGroupModel> groups = [];
  TeacherGroupModel? selectedGroup;

  String paymentStatus = 'مدفوع';
  int _version = 0;

  TeacherEditStudentCubit(
    this._repo, {
    required this.studentId,
    this.initialData,
    this.initialGroupId,
    this.initialGroupName,
  }) : super(const TeacherEditStudentInitial()) {
    _initFields();
    loadLookups();
  }

  void _initFields() {
    if (initialData != null) {
      nameController.text = initialData!.studentInfo.fullName;
      phoneController.text = initialData!.studentInfo.phone;
      parentPhoneController.text = initialData!.studentInfo.parentPhone;
      avatarUrl = initialData!.studentInfo.avatarUrl;
      paymentStatus = initialData!.paymentStatus;
    } else {
      _loadStudentDataFromApi();
    }
  }

  Future<void> _loadStudentDataFromApi() async {
    final res = await _repo.getStudentDetails(studentId);
    res.fold(
      (_) {},
      (response) {
        if (response.data != null) {
          final s = response.data!.studentInfo;
          nameController.text = s.fullName;
          phoneController.text = s.phone;
          parentPhoneController.text = s.parentPhone;
          avatarUrl = s.avatarUrl;
          paymentStatus = response.data!.paymentStatus;
          _notify();
        }
      },
    );
  }

  Future<void> loadLookups() async {
    final stagesRes = await _repo.getStages();
    stagesRes.fold(
      (_) {},
      (stageResponse) {
        stages = stageResponse.data;
        if (initialData != null && stages.isNotEmpty) {
          final targetGradeId = initialData!.studentInfo.gradeLevelId;
          for (final st in stages) {
            for (final gr in st.grades) {
              if (gr.id == targetGradeId || gr.nameAr == initialData!.studentInfo.gradeLevelName) {
                selectedStage = st;
                selectedGrade = gr;
                break;
              }
            }
            if (selectedGrade != null) break;
          }
        }
      },
    );

    final groupsRes = await _repo.getGroups();
    groupsRes.fold(
      (_) {},
      (groupResponse) {
        if (groupResponse.data != null) {
          groups = groupResponse.data!.groups;
          if (initialGroupId != null && initialGroupId!.isNotEmpty) {
            try {
              selectedGroup = groups.firstWhere(
                (g) => g.id == initialGroupId,
                orElse: () => groups.first,
              );
            } catch (_) {
              if (groups.isNotEmpty) selectedGroup = groups.first;
            }
          } else if (groups.isNotEmpty) {
            selectedGroup = groups.first;
          }
        }
      },
    );

    _notify();
  }

  void _notify() {
    _version++;
    emit(TeacherEditStudentDataUpdated(_version));
  }

  Future<void> pickAvatar() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        avatarFile = File(picked.path);
        _notify();
      }
    } catch (_) {}
  }

  void selectStage(AcademicStageModel stage) {
    selectedStage = stage;
    selectedGrade = null;
    _notify();
  }

  void selectGrade(GradeLevelModel grade) {
    selectedGrade = grade;
    _notify();
  }

  void selectGroup(TeacherGroupModel group) {
    selectedGroup = group;
    _notify();
  }

  void selectPaymentStatus(String status) {
    paymentStatus = status;
    _notify();
  }

  Future<void> submitEdit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    emit(const TeacherEditStudentSubmitting());

    final body = EditStudentRequestBody(
      fullName: nameController.text.trim(),
      parentPhone: parentPhoneController.text.trim(),
      gradeLevelId: selectedGrade?.id ?? initialData?.studentInfo.gradeLevelId,
      avatarFile: avatarFile,
    );

    final result = await _repo.updateStudentProfile(studentId, body);
    result.fold(
      (failure) {
        emit(TeacherEditStudentError(failure.message));
      },
      (_) {
        emit(const TeacherEditStudentSuccess('تم تعديل بيانات الطالب بنجاح'));
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    parentPhoneController.dispose();
    return super.close();
  }
}
