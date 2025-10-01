import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.school, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Learning Tracker', style: Theme.of(context).textTheme.titleMedium),
                        Text('College Toolkit', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),

            _DrawerTile(icon: Icons.dashboard_customize_rounded, label: 'Dashboard', onTap: () => context.go(AppRoute.dashboard)),
            _DrawerTile(icon: Icons.menu_book_rounded, label: 'Courses', onTap: () => context.go(AppRoute.courses)),
            _DrawerTile(icon: Icons.event_rounded, label: 'Calendar', onTap: () => context.go(AppRoute.calendar)),
            _DrawerTile(icon: Icons.route, label: 'Routine', onTap: () => context.go(AppRoute.routing)),
            _DrawerTile(icon: Icons.how_to_reg_rounded, label: 'Attendance Tracker', onTap: () => context.go(AppRoute.tracker)),
            _DrawerTile(icon: Icons.task_alt_rounded, label: 'Tasks', onTap: () => context.go(AppRoute.tasks)),
            _DrawerTile(icon: Icons.checklist_rounded, label: 'To-do', onTap: () => context.go(AppRoute.tasks)),
            _DrawerTile(icon: Icons.description_rounded, label: 'Pursuing', onTap: () => context.go(AppRoute.cvMaker)),
            _DrawerTile(icon: Icons.workspace_premium_rounded, label: 'Skills', onTap: () => context.go(AppRoute.skills)),

            const Spacer(),
            const Divider(height: 0),
            _DrawerTile(icon: Icons.settings_rounded, label: 'Settings', onTap: () => context.go(AppRoute.settings)),
            _DrawerTile(icon: Icons.logout_rounded, label: 'Sign out', onTap: () => context.go(AppRoute.landing)),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        // Close the drawer first, then navigate
        Navigator.of(context).pop();
        Future.microtask(onTap);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: cs.onSecondaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}
