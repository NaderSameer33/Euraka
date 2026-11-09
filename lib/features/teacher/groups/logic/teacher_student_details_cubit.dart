import '../../../../core/base/safe_cubit.dart';
import '../data/models/teacher_student_details_model.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'teacher_student_details_state.dart';

class TeacherStudentDetailsCubit extends SafeCubit<TeacherStudentDetailsState> {
  final TeacherGroupsRepo _repo;
  final String studentId;
  final String? initialGroupName;
  bool? currentIsPaid;
  String? currentPaymentStatus;

  TeacherStudentDetailsData? currentData;

  TeacherStudentDetailsCubit(
    this._repo, {
    required this.studentId,
    this.initialGroupName,
    this.currentIsPaid,
    this.currentPaymentStatus,
  }) : super(const TeacherStudentDetailsInitial()) {
    fetchStudentDetails();
  }

  Future<void> fetchStudentDetails() async {
    emit(const TeacherStudentDetailsLoading());
    final result = await _repo.getStudentDetails(studentId);
    result.fold(
      (failure) {
        emit(TeacherStudentDetailsError(failure.message));
      },
      (response) {
        if (response.data != null) {
          var data = response.data!;
          if (currentIsPaid != null) {
            data = data.copyWith(
              isPaid: currentIsPaid,
              paymentStatus: currentPaymentStatus ?? (currentIsPaid! ? 'مدفوع' : 'غير مدفوع'),
            );
          }
          currentData = data;
          emit(TeacherStudentDetailsSuccess(data));
        } else {
          emit(TeacherStudentDetailsError(
            response.message.isNotEmpty
                ? response.message
                : 'لم يتم العثور على بيانات الطالب',
          ));
        }
      },
    );
  }

  void updatePaymentStatus({required bool isPaid, required String paymentStatus}) {
    currentIsPaid = isPaid;
    currentPaymentStatus = paymentStatus;
    if (currentData != null) {
      currentData = currentData!.copyWith(
        isPaid: isPaid,
        paymentStatus: paymentStatus,
      );
      emit(TeacherStudentDetailsSuccess(currentData!));
    }
  }

  void updateStudentInfo({
    String? fullName,
    String? parentPhone,
    String? gradeLevelName,
    bool? isPaid,
    String? paymentStatus,
  }) {
    if (isPaid != null) currentIsPaid = isPaid;
    if (paymentStatus != null) currentPaymentStatus = paymentStatus;

    if (currentData != null) {
      final updatedStudentInfo = currentData!.studentInfo.copyWith(
        fullName: fullName,
        parentPhone: parentPhone,
        gradeLevelName: gradeLevelName,
      );
      currentData = currentData!.copyWith(
        studentInfo: updatedStudentInfo,
        isPaid: currentIsPaid ?? currentData!.isPaid,
        paymentStatus: currentPaymentStatus ?? currentData!.paymentStatus,
      );
      emit(TeacherStudentDetailsSuccess(currentData!));
    }
  }
}
