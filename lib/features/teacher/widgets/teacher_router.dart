import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../pages/teacher_home_page.dart';
import 'teacher_dashboard.dart';
import '../pages/teacher_classes_page.dart';
import '../pages/room_override_page.dart';
import '../pages/teacher_courses_page.dart';
import '../pages/teacher_community_page.dart';
import '../pages/teacher_contacts_page.dart';
import '../pages/teacher_tracker_page.dart';
import '../pages/teacher_sign_in_page.dart';
import '../pages/teacher_sign_up_page.dart';
import '../pages/teacher_settings_page.dart';
import '../pages/teacher_settings_profile_page.dart';
import '../pages/teacher_settings_password_page.dart';
import '../pages/teacher_calendar_page.dart';

RouteBase buildTeacherShell() {
  return ShellRoute(
    builder: (context, state, child) => TeacherHomeShell(child: child),
    routes: teacherRoutes,
  );
}

final List<RouteBase> teacherRoutes = <RouteBase>[
  GoRoute(
    path: AppRoute.teacher,
    name: 'teacher',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherDashboard()),
  ),
  GoRoute(
    path: AppRoute.teacherSignIn,
    name: 'teacher-sign-in',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSignInPage()),
  ),
  GoRoute(
    path: AppRoute.teacherSignUp,
    name: 'teacher-sign-up',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSignUpPage()),
  ),
  GoRoute(
    path: AppRoute.teacherCourses,
    name: 'teacher-courses',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherCoursesPage()),
  ),
  GoRoute(
    path: AppRoute.teacherCommunity,
    name: 'teacher-community',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherCommunityPage()),
  ),
  GoRoute(
    path: AppRoute.teacherContacts,
    name: 'teacher-contacts',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherContactsPage()),
  ),
  GoRoute(
    path: AppRoute.teacherTracker,
    name: 'teacher-tracker',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherTrackerPage()),
  ),
  GoRoute(
    path: AppRoute.teacherCalendar,
    name: 'teacher-calendar',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherCalendarPage()),
  ),
  GoRoute(
    path: AppRoute.teacherClasses,
    name: 'teacher-classes',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherClassesPage()),
  ),
  GoRoute(
    path: AppRoute.teacherRoomOverride,
    name: 'teacher-room-override',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherRoomOverridePage()),
  ),
  // Settings and components (teacher only)
  GoRoute(
    path: AppRoute.teacherSettings,
    name: 'teacher-settings',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSettingsPage()),
  ),
  GoRoute(
    path: AppRoute.teacherSettingsProfile,
    name: 'teacher-settings-profile',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSettingsProfilePage()),
  ),
  GoRoute(
    path: AppRoute.teacherSettingsPassword,
    name: 'teacher-settings-password',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSettingsPasswordPage()),
  ),
];
