import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../pages/admin_home_page.dart';
import 'admin_dashboard.dart';
import '../pages/admin_users_page.dart';
import '../pages/admin_routine_setup_page.dart';
import '../pages/admin_courses_page.dart';
import '../pages/admin_community_page.dart';
import '../pages/admin_contacts_page.dart';
import '../pages/admin_tracker_page.dart';
import '../pages/admin_sign_in_page.dart';
import '../pages/admin_sign_up_page.dart';
import '../pages/admin_student_admission_page.dart';
import '../pages/admin_student_updation_page.dart';
import '../pages/admin_teacher_joining_page.dart';
import '../pages/admin_teacher_updation_page.dart';
import '../pages/admin_settings_page.dart';
import '../pages/admin_settings_profile_page.dart';
import '../pages/admin_settings_password_page.dart';
import '../pages/admin_calendar_page.dart';

RouteBase buildAdminShell() {
  return ShellRoute(
    builder: (context, state, child) => AdminHomeShell(child: child),
    routes: adminRoutes,
  );
}

final List<RouteBase> adminRoutes = <RouteBase>[
  GoRoute(
    path: AppRoute.admin,
    name: 'admin',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminDashboard()),
  ),
  GoRoute(
    path: AppRoute.adminSignIn,
    name: 'admin-sign-in',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminSignInPage()),
  ),
  GoRoute(
    path: AppRoute.adminSignUp,
    name: 'admin-sign-up',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminSignUpPage()),
  ),
  GoRoute(
    path: AppRoute.adminCourses,
    name: 'admin-courses',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminCoursesPage()),
  ),
  GoRoute(
    path: AppRoute.adminCommunity,
    name: 'admin-community',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminCommunityPage()),
  ),
  GoRoute(
    path: AppRoute.adminContacts,
    name: 'admin-contacts',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminContactsPage()),
  ),
  GoRoute(
    path: AppRoute.adminTracker,
    name: 'admin-tracker',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminTrackerPage()),
  ),
  GoRoute(
    path: AppRoute.adminCalendar,
    name: 'admin-calendar',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminCalendarPage()),
  ),
  GoRoute(
    path: AppRoute.adminSettings,
    name: 'admin-settings',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminSettingsPage()),
  ),
  GoRoute(
    path: AppRoute.adminSettingsProfile,
    name: 'admin-settings-profile',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminSettingsProfilePage()),
  ),
  GoRoute(
    path: AppRoute.adminSettingsPassword,
    name: 'admin-settings-password',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminSettingsPasswordPage()),
  ),
  GoRoute(
    path: AppRoute.adminUsers,
    name: 'admin-users',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminUsersPage()),
  ),
  GoRoute(
    path: AppRoute.adminRoutine,
    name: 'admin-routine',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminRoutineSetupPage()),
  ),
  GoRoute(
    path: AppRoute.adminStudentAdmission,
    name: 'admin-student-admission',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminStudentAdmissionPage()),
  ),
  GoRoute(
    path: AppRoute.adminStudentUpdation,
    name: 'admin-student-updation',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminStudentUpdationPage()),
  ),
  GoRoute(
    path: AppRoute.adminTeacherJoining,
    name: 'admin-teacher-joining',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminTeacherJoiningPage()),
  ),
  GoRoute(
    path: AppRoute.adminTeacherUpdation,
    name: 'admin-teacher-updation',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminTeacherUpdationPage()),
  ),
  // Backward compatibility: direct the old Room Override path to Routine page
  GoRoute(
    path: AppRoute.adminRoomOverride,
    name: 'admin-room-override',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminRoutineSetupPage()),
  ),
];
