import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/landing_page.dart';
import 'features/student/widgets/student_router.dart';
import 'features/teacher/widgets/teacher_router.dart';

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
  static const settings = '/student/settings';
  static const community = '/student/community';
  static const contacts = '/student/contacts';
  static const tracker = '/student/tracker';
  static const routing = '/student/routing';
  static const signIn = '/student/sign-in';
  static const signUp = '/student/sign-up';
  static const cvMaker = '/student/cv-maker';
  static const skills = '/student/skills';
  // Teacher namespace
  static const teacher = '/teacher';
  static const teacherClasses = '/teacher/classes';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.landing,
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
    ],
  );
});
