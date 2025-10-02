import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../pages/admin_home_page.dart';
import 'admin_dashboard.dart';
import '../pages/admin_users_page.dart';
import '../pages/admin_routine_setup_page.dart';
import '../pages/admin_room_override_page.dart';

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
    path: AppRoute.adminRoomOverride,
    name: 'admin-room-override',
    pageBuilder: (context, state) => const NoTransitionPage(child: AdminRoomOverridePage()),
  ),
];
