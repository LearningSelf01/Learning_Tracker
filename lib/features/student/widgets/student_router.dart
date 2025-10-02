import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../pages/home_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/courses_page.dart';
import '../pages/calendar_page.dart';
import '../pages/tasks_page.dart';
import '../pages/settings_page.dart';
import '../pages/community_page.dart';
import '../pages/contacts_page.dart';
import '../pages/tracker_page.dart';
import '../pages/routing_page.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';
import '../pages/cv_maker_page.dart';
import '../pages/skills_page.dart';

RouteBase buildStudentShell() {
  return ShellRoute(
    builder: (context, state, child) => HomeShell(child: child),
    routes: studentRoutes,
  );
}

final List<RouteBase> studentRoutes = <RouteBase>[
  GoRoute(
    path: AppRoute.dashboard,
    name: 'dashboard',
    pageBuilder: (context, state) => const NoTransitionPage(child: DashboardPage()),
  ),
  GoRoute(
    path: AppRoute.courses,
    name: 'courses',
    pageBuilder: (context, state) => const NoTransitionPage(child: CoursesPage()),
  ),
  GoRoute(
    path: AppRoute.community,
    name: 'community',
    pageBuilder: (context, state) => const NoTransitionPage(child: CommunityPage()),
  ),
  GoRoute(
    path: AppRoute.contacts,
    name: 'contacts',
    pageBuilder: (context, state) => const NoTransitionPage(child: ContactsPage()),
  ),
  GoRoute(
    path: AppRoute.calendar,
    name: 'calendar',
    pageBuilder: (context, state) => const NoTransitionPage(child: CalendarPage()),
  ),
  GoRoute(
    path: AppRoute.tasks,
    name: 'tasks',
    pageBuilder: (context, state) => const NoTransitionPage(child: TasksPage()),
  ),
  GoRoute(
    path: AppRoute.cvMaker,
    name: 'cv-maker',
    pageBuilder: (context, state) => const NoTransitionPage(child: CvMakerPage()),
  ),
  GoRoute(
    path: AppRoute.skills,
    name: 'skills',
    pageBuilder: (context, state) => const NoTransitionPage(child: SkillsPage()),
  ),
  GoRoute(
    path: AppRoute.routing,
    name: 'routing',
    pageBuilder: (context, state) => const NoTransitionPage(child: RoutingPage()),
  ),
  GoRoute(
    path: AppRoute.tracker,
    name: 'tracker',
    pageBuilder: (context, state) => const NoTransitionPage(child: TrackerPage()),
  ),
  GoRoute(
    path: AppRoute.settings,
    name: 'settings',
    pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
  ),
  GoRoute(
    path: AppRoute.signIn,
    name: 'sign-in',
    pageBuilder: (context, state) => const NoTransitionPage(child: SignInPage()),
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) return AppRoute.dashboard;
      return null;
    },
  ),
  GoRoute(
    path: AppRoute.signUp,
    name: 'sign-up',
    pageBuilder: (context, state) => const NoTransitionPage(child: SignUpPage()),
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) return AppRoute.dashboard;
      return null;
    },
  ),
];
