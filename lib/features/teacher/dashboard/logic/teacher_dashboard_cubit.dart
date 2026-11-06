import '../../../../core/base/safe_cubit.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/get_it_service.dart';
import '../data/models/teacher_dashboard_response_model.dart';
import '../data/repos/teacher_dashboard_repo.dart';
import 'teacher_dashboard_state.dart';

class TeacherDashboardCubit extends SafeCubit<TeacherDashboardState> {
  final TeacherDashboardRepo _repo;
  final SharedPrefService _sharedPref;

  TeacherDashboardCubit({
    TeacherDashboardRepo? repo,
    SharedPrefService? sharedPref,
  })  : _repo = repo ?? getIt<TeacherDashboardRepo>(),
        _sharedPref = sharedPref ?? getIt<SharedPrefService>(),
        super(const TeacherDashboardInitialState()) {
    loadDashboard();
  }

  String get teacherName {
    final email = _sharedPref.getString(AppConstants.userEmailKey);
    if (email != null && email.contains('@')) {
      final namePart = email.split('@').first;
      if (namePart.isNotEmpty) {
        return 'أ/ ${namePart[0].toUpperCase()}${namePart.substring(1)}';
      }
    }
    return 'أ/ أحمد';
  }

  Future<void> loadDashboard({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const TeacherDashboardLoadingState());
    }

    final result = await _repo.getDashboardData();

    result.fold(
      (failure) {
        emit(TeacherDashboardErrorState(message: failure.message));
      },
      (response) {
        if (response.data != null) {
          emit(TeacherDashboardSuccessState(
            data: response.data!,
            teacherName: teacherName,
          ));
        } else {
          emit(TeacherDashboardSuccessState(
            data: const TeacherDashboardData(
              kpis: TeacherKpisModel(),
              activeExams: [],
              recentGroups: [],
            ),
            teacherName: teacherName,
          ));
        }
      },
    );
  }

  static TeacherDashboardData dummyData() {
    return const TeacherDashboardData(
      kpis: TeacherKpisModel(
        totalStudents: 127,
        totalStudentsGrowthPercent: 12,
        activeGroupsCount: 5,
        activeGroupsGrowthPercent: 3,
        activeExamsCount: 8,
        activeExamsGrowthPercent: 8,
        collectionRatePercentage: 75,
        collectionGrowthPercent: 6,
      ),
      activeExams: [
        TeacherActiveExamModel(
          id: '1',
          title: 'مجموعة الرياضيات A',
          groupName: 'مجموعة الرياضيات A',
          subjectName: 'الرياضيات',
          durationMinutes: 45,
          submissionsCount: 25,
        ),
      ],
      recentGroups: [
        TeacherRecentGroupModel(
          id: '1',
          name: 'مجموعة الفيزياء A',
          subjectName: 'الفيزياء',
          gradeLevelName: 'الصف الأول الثانوي',
          studentCount: 25,
        ),
        TeacherRecentGroupModel(
          id: '2',
          name: 'مجموعة الأحياء C',
          subjectName: 'الأحياء',
          gradeLevelName: 'الصف الأول الثانوي',
          studentCount: 22,
        ),
      ],
    );
  }
}
