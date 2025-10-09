import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../../../core/last_area.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
                    radius: 24,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.admin_panel_settings, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Portal', style: Theme.of(context).textTheme.titleMedium),
                        Text('Learning Tracker', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            // Primary admin actions in requested order
            _Tile(icon: Icons.dashboard, label: 'Dashboard', onTap: () => context.go(AppRoute.admin)),
            _Tile(
              icon: Icons.calendar_month,
              label: 'Calendar',
              onTap: () => context.go(AppRoute.adminCalendar),
            ),
            _Tile(
              icon: Icons.person_add,
              label: 'Student Admission',
              onTap: () => context.go(AppRoute.adminStudentAdmission),
            ),
            _Tile(
              icon: Icons.edit,
              label: 'Student Updation',
              onTap: () => context.go(AppRoute.adminStudentUpdation),
            ),
            _Tile(
              icon: Icons.school,
              label: 'Teacher Joining',
              onTap: () => context.go(AppRoute.adminTeacherJoining),
            ),
            _Tile(
              icon: Icons.manage_accounts,
              label: 'Teacher Updation',
              onTap: () => context.go(AppRoute.adminTeacherUpdation),
            ),
            const Divider(height: 0),
            _Tile(icon: Icons.group, label: 'Users', onTap: () => context.go(AppRoute.adminUsers)),
            _Tile(icon: Icons.table_view_outlined, label: 'Routine', onTap: () => context.go(AppRoute.adminRoutine)),
            const Spacer(),
            const Divider(height: 0),
            _Tile(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => context.go(AppRoute.adminSettings),
            ),
            _Tile(
              icon: Icons.logout_rounded,
              label: 'Sign out',
              onTap: () async {
                // Sign out: Only navigate to default page. Do nothing else.
                if (context.mounted) context.go(AppRoute.landing);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Future.microtask(onTap);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(color: cs.secondaryContainer, borderRadius: BorderRadius.circular(10)),
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
