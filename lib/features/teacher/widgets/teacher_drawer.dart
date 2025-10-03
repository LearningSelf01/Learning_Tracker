import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../../../core/last_area.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

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
                    child: Icon(Icons.school, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Teacher Portal', style: Theme.of(context).textTheme.titleMedium),
                        Text('Learning Tracker', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            _DrawerTile(
              icon: Icons.dashboard_customize_rounded,
              label: 'Dashboard',
              onTap: () => context.go(AppRoute.teacher),
            ),
            _DrawerTile(
              icon: Icons.class_outlined,
              label: 'Classes',
              onTap: () => context.go(AppRoute.teacherClasses),
            ),
            _DrawerTile(
              icon: Icons.meeting_room_outlined,
              label: 'Room Override',
              onTap: () => context.go(AppRoute.teacherRoomOverride),
            ),
            const Spacer(),
            const Divider(height: 0),
            _DrawerTile(
              icon: Icons.settings_rounded,
              label: 'Settings',
              onTap: () {
                // Placeholder: keep teacher namespace but no page yet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Teacher settings coming soon')),
                );
              },
            ),
            _DrawerTile(
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
        Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) => onTap());
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
