import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';
import 'widgets/app_drawer.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoute.courses)) return 1;
    if (location.startsWith(AppRoute.community)) return 2;
    if (location.startsWith(AppRoute.contacts)) return 3;
    if (location.startsWith(AppRoute.tracker)) return 4;
    return 0; // dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.dashboard);
        break;
      case 1:
        context.go(AppRoute.courses);
        break;
      case 2:
        context.go(AppRoute.community);
        break;
      case 3:
        context.go(AppRoute.contacts);
        break;
      case 4:
        context.go(AppRoute.tracker);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Tracker'),
        actions: [
          // Notifications bell with a small badge
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications tapped')),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              // Placeholder action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile tapped')),
              );
            },
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onItemTapped(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), selectedIcon: Icon(Icons.people_alt), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.track_changes_outlined), selectedIcon: Icon(Icons.track_changes), label: 'Tracker'),
        ],
      ),
    );
  }
}
