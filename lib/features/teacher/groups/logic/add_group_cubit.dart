import 'package:flutter/material.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helper/helper_method.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/academic_subject_model.dart';
import '../data/models/create_group_request_body.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'add_group_state.dart';

class AddGroupCubit extends SafeCubit<AddGroupState> {
  final TeacherGroupsRepo _repo;
  final SharedPrefService _sharedPref;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<AcademicStageModel> stages = [];
  List<AcademicSubjectModel> subjects = [];
  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;
  AcademicSubjectModel? selectedSubject;

  AddGroupCubit(
    this._repo,
    this._sharedPref,
  ) : super(const AddGroupInitialState()) {
    _initTeacherName();
    loadLookups();
  }

  void _initTeacherName() {
    final savedName = _sharedPref.getString(AppConstants.userFullNameKey);
    if (savedName != null && savedName.trim().isNotEmpty) {
      teacherNameController.text = savedName.trim();
    }
  }

  Future<void> loadLookups() async {
    final stagesRes = await _repo.getStages();
    stagesRes.fold(
      (_) {},
      (response) {
        stages = response.data;
      },
    );

    final subjectsRes = await _repo.getSubjects();
    subjectsRes.fold(
      (_) {},
      (response) {
        subjects = response.data;
      },
    );

    _emitLookups();
  }

  void selectGrade(AcademicStageModel stage, GradeLevelModel grade) {
    selectedStage = stage;
    selectedGrade = grade;
    _emitLookups();
  }

  void selectSubject(AcademicSubjectModel subject) {
    selectedSubject = subject;
    _emitLookups();
  }

  void _emitLookups() {
    emit(AddGroupLookupsLoadedState(
      stages: stages,
      subjects: subjects,
      selectedStage: selectedStage,
      selectedGrade: selectedGrade,
      selectedSubject: selectedSubject,
    ));
  }

  Future<void> createGroup(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedGrade == null || selectedStage == null) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى اختيار الصف الدراسي',
      );
      return;
    }

    if (selectedSubject == null) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'يرجى اختيار المادة الدراسية',
      );
      return;
    }

    emit(const AddGroupLoadingState());

    final body = CreateGroupRequestBody(
      name: nameController.text.trim(),
      subjectId: selectedSubject!.id,
      stageId: selectedStage!.id,
      gradeLevelId: selectedGrade!.id,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : 'مجموعة تعليمية',
    );

    final result = await _repo.createGroup(body);

    result.fold(
      (failure) {
        emit(AddGroupErrorState(message: failure.message));
        if (context.mounted) {
          HelperMethod.showErrorToast(
            context: context,
            message: failure.message,
          );
        }
      },
      (response) {
        if (response.data != null) {
          emit(AddGroupSuccessState(response.data!));
          if (context.mounted) {
            HelperMethod.showSuccessToast(
              context: context,
              message: 'تم إنشاء المجموعة بنجاح',
            );
            Navigator.of(context).pop(true);
          }
        } else {
          emit(AddGroupErrorState(message: response.message));
        }
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    teacherNameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}

