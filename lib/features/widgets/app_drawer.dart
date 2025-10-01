import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';

// This legacy drawer is kept minimal for the default/landing context only.
// Student and Teacher sections have their own drawers under their respective folders.
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
                    radius: 24,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.school, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Learning Tracker', style: Theme.of(context).textTheme.titleMedium),
                        Text('Default Menu', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Landing Page'),
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoute.landing);
              },
            ),
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Use the buttons on the landing page to enter Student or Teacher apps.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
