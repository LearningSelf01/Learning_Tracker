import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/last_area.dart';

import 'features/auth/landing_page.dart';
import 'features/student/widgets/student_router.dart';
import 'features/teacher/widgets/teacher_router.dart';
import 'features/admin/widgets/admin_router.dart';

// Route names
class AppRoute {
  // Default landing
  static const landing = '/';

  // Student namespace
  static const studentRoot = '/student';
  static const dashboard = '/student';
  static const courses = '/student/courses';
  static const calendar = '/student/calendar';
  static const tasks = '/student/tasks';
  static const todo = '/student/todo';
  static const settings = '/student/settings';
  static const settingsProfile = '/student/settings/profile';
  static const settingsStudentDetails = '/student/settings/student-details';
  static const settingsAddress = '/student/settings/address';
  static const settingsPassword = '/student/settings/password';
  static const settingsFamily = '/student/settings/family';
  static const userProfile = '/student/user-profile';
  static const community = '/student/community';
  static const contacts = '/student/contacts';
  static const tracker = '/student/tracker';
  static const attendance = '/student/attendance';
  static const routing = '/student/routing';
  static const signIn = '/student/sign-in';
  static const signUp = '/student/sign-up';
  static const cvMaker = '/student/cv-maker';
  static const skills = '/student/skills';
  // Teacher namespace
  static const teacher = '/teacher';
  static const teacherClasses = '/teacher/classes';
  static const teacherRoomOverride = '/teacher/room-override';
  static const teacherCourses = '/teacher/courses';
  static const teacherCommunity = '/teacher/community';
  static const teacherContacts = '/teacher/contacts';
  static const teacherTracker = '/teacher/tracker';
  static const teacherCalendar = '/teacher/calendar';
  static const teacherSignIn = '/teacher/sign-in';
  static const teacherSignUp = '/teacher/sign-up';
  static const teacherSettings = '/teacher/settings';
  static const teacherSettingsProfile = '/teacher/settings/profile';
  static const teacherSettingsPassword = '/teacher/settings/password';

  // Admin namespace
  static const adminRoot = '/admin';
  static const admin = '/admin';
  static const adminSignIn = '/admin/sign-in';
  static const adminSignUp = '/admin/sign-up';
  static const adminUsers = '/admin/users';
  static const adminRoutine = '/admin/routine';
  static const adminRoomOverride = '/admin/room-override';
  static const adminCourses = '/admin/courses';
  static const adminCommunity = '/admin/community';
  static const adminContacts = '/admin/contacts';
  static const adminTracker = '/admin/tracker';
  static const adminCalendar = '/admin/calendar';
  static const adminSettings = '/admin/settings';
  static const adminSettingsProfile = '/admin/settings/profile';
  static const adminSettingsPassword = '/admin/settings/password';
  // New admin pages
  static const adminStudentAdmission = '/admin/student-admission';
  static const adminStudentUpdation = '/admin/student-updation';
  static const adminTeacherJoining = '/admin/teacher-joining';
  static const adminTeacherUpdation = '/admin/teacher-updation';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Listen to Supabase auth state to refresh router on sign in/out
  final authStream = Supabase.instance.client.auth.onAuthStateChange;
  final user = Supabase.instance.client.auth.currentUser;
  final last = LastArea.cached;
  final initial = last == 'teacher'
      ? AppRoute.teacher
      : last == 'student'
          ? AppRoute.dashboard
          : last == 'admin'
              ? AppRoute.admin
              : user == null
                  ? AppRoute.landing
                  : AppRoute.dashboard;
  return GoRouter(
    initialLocation: initial,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) async {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;

      // Public routes allowed without auth
      const publicPaths = {
        AppRoute.landing,
        AppRoute.signIn,
        AppRoute.signUp,
        AppRoute.teacherSignIn,
        AppRoute.teacherSignUp,
        AppRoute.adminSignIn,
        AppRoute.adminSignUp,
      };

      final path = state.uri.toString();

      // If not signed in: allow only public paths
      if (user == null) {
        final isPublic = publicPaths.any((p) => path.startsWith(p));
        return isPublic ? null : AppRoute.landing;
      }

      // Fast path: if already within a known namespace, skip role lookup
      final isInStudent = path.startsWith(AppRoute.studentRoot);
      final isInTeacher = path.startsWith(AppRoute.teacher);
      final isInAdmin = path.startsWith(AppRoute.adminRoot) || path.startsWith(AppRoute.admin);
      if (isInStudent || isInTeacher || isInAdmin) {
        return null;
      }

      // Signed in: look up role and send to proper area root if needed
      try {
        final data = await client
            .from('profiles')
            .select('user_type')
            .eq('id', user.id)
            .maybeSingle();

        final role = (data?['user_type'] as String?) ?? 'student';

        // Persist last area for initial boot optimization
        if (role == 'teacher') {
          await LastArea.setTeacher();
        } else if (role == 'admin') {
          await LastArea.setAdmin();
        } else {
          await LastArea.setStudent();
        }

        // If already under correct namespace, do nothing (handled above). Otherwise route to root.
        if (role == 'teacher') return AppRoute.teacher;
        if (role == 'admin') return AppRoute.admin;
        if (role == 'student') return AppRoute.dashboard;

        return null;
      } catch (_) {
        // On failure to read profile, default to student area
        await LastArea.setStudent();
        return AppRoute.dashboard;
      }
    },
    routes: [
      // Landing page
      GoRoute(
        path: AppRoute.landing,
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),

      // Student and Teacher sections mounted via modular routers
      buildStudentShell(),
      buildTeacherShell(),
      buildAdminShell(),
    ],
  );
});

// Simple ChangeNotifier wrapper to refresh GoRouter on auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      // Debounce rapid successive auth events
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 250), () {
        if (hasListeners) notifyListeners();
      });
    });
  }

  late final StreamSubscription<dynamic> _subscription;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _subscription.cancel();
    super.dispose();
  }
}
