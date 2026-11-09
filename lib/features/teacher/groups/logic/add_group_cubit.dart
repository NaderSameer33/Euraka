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
import '../data/models/academic_subject_model.dart';
import '../data/models/create_group_request_body.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'add_group_state.dart';

class AddGroupCubit extends SafeCubit<AddGroupState> {
  final TeacherGroupsRepo _repo;
  final SharedPrefService _sharedPref;
  final SecureStorageService _secureStorage;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<AcademicStageModel> stages = [];
  List<AcademicSubjectModel> subjects = [];
  AcademicStageModel? selectedStage;
  GradeLevelModel? selectedGrade;
  AcademicSubjectModel? selectedSubject;
  File? coverFile;
  File? teacherPhotoFile;
  int _version = 0;

  AddGroupCubit(
    this._repo,
    this._sharedPref,
    this._secureStorage,
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

  Future<void> pickCoverImage(BuildContext context) async {
    final source = await _selectImageSource(context);
    if (source == null) return;
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        coverFile = File(picked.path);
        _version++;
        _emitLookups();
      }
    } catch (e) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر فتح الصور، يرجى إعادة تشغيل التطبيق بالكامل والتأكد من الصلاحيات',
        );
      }
    }
  }

  void removeCoverImage() {
    coverFile = null;
    _version++;
    _emitLookups();
  }

  Future<void> pickTeacherPhoto(BuildContext context) async {
    final source = await _selectImageSource(context);
    if (source == null) return;
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        teacherPhotoFile = File(picked.path);
        _version++;
        _emitLookups();
      }
    } catch (e) {
      if (context.mounted) {
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر فتح الصور، يرجى إعادة تشغيل التطبيق بالكامل والتأكد من الصلاحيات',
        );
      }
    }
  }

  void removeTeacherPhoto() {
    teacherPhotoFile = null;
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
    emit(AddGroupLookupsLoadedState(
      stages: stages,
      subjects: subjects,
      selectedStage: selectedStage,
      selectedGrade: selectedGrade,
      selectedSubject: selectedSubject,
      coverFile: coverFile,
      teacherPhotoFile: teacherPhotoFile,
      version: _version,
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

    emit(const AddGroupLoadingState());

    final body = CreateGroupRequestBody(
      name: nameController.text.trim(),
      subjectId: selectedSubject!.id,
      stageId: selectedStage!.id,
      gradeLevelId: selectedGrade!.id,
      teacherId: teacherId,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : 'مجموعة تعليمية',
      coverFile: coverFile,
      teacherPhotoFile: teacherPhotoFile,
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
