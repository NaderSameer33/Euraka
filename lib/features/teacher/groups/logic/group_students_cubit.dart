import '../../../../core/base/safe_cubit.dart';
import '../data/models/group_student_model.dart';
import '../data/repos/teacher_groups_repo.dart';
import 'group_students_state.dart';

class GroupStudentsCubit extends SafeCubit<GroupStudentsState> {
  final TeacherGroupsRepo _repo;
  final String groupId;
  final String initialGroupName;

  GroupStudentsCubit(
    this._repo, {
    required this.groupId,
    this.initialGroupName = 'المجموعة',
  }) : super(const GroupStudentsInitialState()) {
    loadStudents();
  }

  Future<void> loadStudents({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const GroupStudentsLoadingState());
    }

    final result = await _repo.getGroupStudents(groupId);

    result.fold(
      (failure) {
        emit(GroupStudentsErrorState(message: failure.message));
      },
      (response) {
        final data = response.data;
        final students = data?.students ?? [];
        final name = (data != null && data.groupName.isNotEmpty)
            ? data.groupName
            : initialGroupName;
        final code = data?.groupCode ?? '';

        emit(GroupStudentsSuccessState(
          groupName: name,
          groupCode: code,
          students: students,
          filteredStudents: students,
        ));
      },
    );
  }

  void searchStudents(String query) {
    if (state is! GroupStudentsSuccessState) return;
    final currentState = state as GroupStudentsSuccessState;
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      emit(GroupStudentsSuccessState(
        groupName: currentState.groupName,
        groupCode: currentState.groupCode,
        students: currentState.students,
        filteredStudents: currentState.students,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.students.where((student) {
      final matchName = student.fullName.toLowerCase().contains(trimmed);
      final matchPhone = student.phone.contains(trimmed);
      return matchName || matchPhone;
    }).toList();

    emit(GroupStudentsSuccessState(
      groupName: currentState.groupName,
      groupCode: currentState.groupCode,
      students: currentState.students,
      filteredStudents: filtered,
      searchQuery: query,
    ));
  }

  static List<GroupStudentModel> dummyStudents() {
    return const [
      GroupStudentModel(
        enrollmentId: '1',
        studentId: '1',
        userId: '1',
        fullName: 'طالب في المجموعة',
        phone: '01000000000',
        isPaid: true,
        paymentStatus: 'مدفوع',
      ),
      GroupStudentModel(
        enrollmentId: '2',
        studentId: '2',
        userId: '2',
        fullName: 'طالب في المجموعة',
        phone: '01000000000',
        isPaid: false,
        paymentStatus: 'غير مدفوع',
      ),
      GroupStudentModel(
        enrollmentId: '3',
        studentId: '3',
        userId: '3',
        fullName: 'طالب في المجموعة',
        phone: '01000000000',
        isPaid: true,
        paymentStatus: 'مدفوع',
      ),
      GroupStudentModel(
        enrollmentId: '4',
        studentId: '4',
        userId: '4',
        fullName: 'طالب في المجموعة',
        phone: '01000000000',
        isPaid: false,
        paymentStatus: 'غير مدفوع',
      ),
    ];
  }
}

