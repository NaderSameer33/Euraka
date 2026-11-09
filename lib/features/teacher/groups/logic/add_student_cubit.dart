import 'package:flutter/material.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/helper/helper_method.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/add_student_request_body.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'add_student_state.dart';

class AddStudentCubit extends SafeCubit<AddStudentState> {
  final TeacherGroupsRepo _repo;
  final String groupId;
  final int defaultPrice;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();

  List<AcademicStageModel> stages = [];
  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;

  AddStudentCubit(
    this._repo, {
    required this.groupId,
    this.defaultPrice = 300,
  }) : super(const AddStudentInitialState()) {
    loadLookups();
  }

  Future<void> loadLookups() async {
    final stagesRes = await _repo.getStages();
    stagesRes.fold(
      (_) {},
      (response) {
        stages = response.data;
        if (stages.isNotEmpty && stages.first.grades.isNotEmpty) {
          selectedStage = stages.first;
          selectedGrade = stages.first.grades.first;
        }
        _emitLookups();
      },
    );
  }

  void selectGrade(AcademicStageModel stage, GradeLevelModel grade) {
    selectedStage = stage;
    selectedGrade = grade;
    _emitLookups();
  }

  void _emitLookups() {
    emit(AddStudentLookupsLoadedState(
      stages: stages,
      selectedStage: selectedStage,
      selectedGrade: selectedGrade,
    ));
  }

  Future<void> addStudent(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(const AddStudentLoadingState());

    final body = AddStudentRequestBody(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      parentPhone: parentPhoneController.text.trim(),
      enrollmentPrice: defaultPrice,
    );

    final result = await _repo.addStudentToGroup(groupId, body);

    result.fold(
      (failure) {
        emit(AddStudentErrorState(message: failure.message));
        if (context.mounted) {
          HelperMethod.showErrorToast(
            context: context,
            message: failure.message,
          );
        }
      },
      (response) {
        if (response.data != null) {
          emit(AddStudentSuccessState(response.data!));
          if (context.mounted) {
            HelperMethod.showSuccessToast(
              context: context,
              message: response.message.isNotEmpty
                  ? response.message
                  : 'تم تسجيل الطالب في المجموعة بنجاح',
            );
            Navigator.of(context).pop(true);
          }
        } else {
          emit(AddStudentErrorState(message: response.message));
        }
      },
    );
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    parentPhoneController.dispose();
    return super.close();
  }
}

