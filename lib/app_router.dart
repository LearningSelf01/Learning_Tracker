import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_page.dart';
import 'features/pages/dashboard_page.dart';
import 'features/pages/courses_page.dart';
import 'features/pages/calendar_page.dart';
import 'features/pages/tasks_page.dart';
import 'features/pages/settings_page.dart';
import 'features/pages/community_page.dart';
import 'features/pages/contacts_page.dart';
import 'features/pages/tracker_page.dart';
import 'features/pages/routing_page.dart';

// Route names
class AppRoute {
  static const dashboard = '/';
  static const courses = '/courses';
  static const calendar = '/calendar';
  static const tasks = '/tasks';
  static const settings = '/settings';
  static const community = '/community';
  static const contacts = '/contacts';
  static const tracker = '/tracker';
  static const routing = '/routing';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.dashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
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
        ],
      ),
    ],
  );
});
