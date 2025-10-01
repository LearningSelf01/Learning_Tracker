import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../widgets/teacher_drawer.dart';

class TeacherHomeShell extends StatefulWidget {
  const TeacherHomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<TeacherHomeShell> createState() => _TeacherHomeShellState();
}

class _TeacherHomeShellState extends State<TeacherHomeShell> {
  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoute.teacherClasses)) return 1;
    return 0; // dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.teacher);
        break;
      case 1:
        context.go(AppRoute.teacherClasses);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
      ),
      drawer: const TeacherDrawer(),
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
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Classes',
          ),
        ],
      ),
    );
  }
}
