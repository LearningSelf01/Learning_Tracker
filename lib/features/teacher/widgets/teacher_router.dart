import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../pages/teacher_home_page.dart';
import 'teacher_dashboard.dart';
import '../pages/teacher_classes_page.dart';

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
    path: AppRoute.teacherClasses,
    name: 'teacher-classes',
    pageBuilder: (context, state) => const NoTransitionPage(child: TeacherClassesPage()),
  ),
];
