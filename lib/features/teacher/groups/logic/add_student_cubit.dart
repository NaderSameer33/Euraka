import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/secure_storage_service.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/helper/helper_method.dart';
import '../../../../core/theme/app_styles.dart';
import '../data/models/academic_stage_model.dart';
import '../data/models/add_student_request_body.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'add_student_state.dart';

class AddStudentCubit extends SafeCubit<AddStudentState> {
  final TeacherGroupsRepo _repo;
  final SharedPrefService _sharedPref;
  final SecureStorageService _secureStorage;
  final ImagePicker _imagePicker = ImagePicker();

  final String groupId;
  final int defaultPrice;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();

  List<AcademicStageModel> stages = [];
  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;
  File? photoFile;
  int _version = 0;

  AddStudentCubit(
    this._repo,
    this._sharedPref,
    this._secureStorage, {
    required this.groupId,
    this.defaultPrice = 300,
  }) : super(const AddStudentInitialState()) {
    loadLookups();
  }

  Future<String?> _getTeacherId() async {
    final cachedId = _sharedPref.getString(AppConstants.userIdKey);
    if (cachedId != null && cachedId.trim().isNotEmpty) {
      return cachedId.trim();
    }
    final token = await _secureStorage.read(AppConstants.userTokenKey);
    if (token != null && token.isNotEmpty) {
      final id = _extractIdFromJwt(token);
      if (id != null && id.isNotEmpty) {
        await _sharedPref.setString(AppConstants.userIdKey, id);
        return id;
      }
    }
    return null;
  }

  String? _extractIdFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final normalized = base64Url.normalize(parts[1]);
        final payloadString = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> payload = jsonDecode(payloadString) as Map<String, dynamic>;
        return payload['id'] as String?;
      }
    } catch (_) {}
    return null;
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

  Future<void> pickStudentPhoto(BuildContext context) async {
    final source = await _selectImageSource(context);
    if (source == null) return;
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        photoFile = File(picked.path);
        _version++;
        _emitLookups();
      }
    } catch (e) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر فتح الصور، يرجى إعادة تشغيل التطبيق والتأكد من الصلاحيات',
        );
      }
    }
  }

  void removeStudentPhoto() {
    photoFile = null;
    _version++;
    _emitLookups();
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
                  style: AppStyles.font16Bold(ctx),
                ),
                16.verticalSpace,
                ListTile(
                  leading: Icon(Icons.photo_library_outlined, color: colorScheme.primary),
                  title: Text('معرض الصور', style: AppStyles.font14Regular(ctx)),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined, color: colorScheme.primary),
                  title: Text('الكاميرا', style: AppStyles.font14Regular(ctx)),
                  onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _emitLookups() {
    emit(AddStudentLookupsLoadedState(
      stages: stages,
      selectedStage: selectedStage,
      selectedGrade: selectedGrade,
      photoFile: photoFile,
      version: _version,
    ));
  }

  Future<void> addStudent(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final teacherId = await _getTeacherId();
    if (teacherId == null || teacherId.isEmpty) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر تحديد هوية المعلم، يرجى إعادة تسجيل الدخول',
        );
      }
      return;
    }

    emit(const AddStudentLoadingState());

    final body = AddStudentRequestBody(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      parentPhone: parentPhoneController.text.trim(),
      enrollmentPrice: defaultPrice,
      teacherId: teacherId,
      stageId: selectedStage?.id,
      gradeLevelId: selectedGrade?.id,
      photoFile: photoFile,
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
