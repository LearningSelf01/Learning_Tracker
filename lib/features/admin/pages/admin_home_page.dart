import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../widgets/admin_drawer.dart';
import '../../../core/last_area.dart';

class AdminHomeShell extends StatefulWidget {
  const AdminHomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<AdminHomeShell> createState() => _AdminHomeShellState();
}

class _AdminHomeShellState extends State<AdminHomeShell> {
  @override
  void initState() {
    super.initState();
    // Remember last used area as admin
    LastArea.setAdmin();
  }

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoute.adminUsers)) return 1;
    return 0; // dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.admin);
        break;
      case 1:
        context.go(AppRoute.adminUsers);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: AppBar(title: const Text('Administrator')),
      drawer: const AdminDrawer(),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onItemTapped(context, i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
