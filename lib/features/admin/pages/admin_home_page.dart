import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    if (location.startsWith(AppRoute.adminCourses)) return 1;
    if (location.startsWith(AppRoute.adminCommunity)) return 2;
    if (location.startsWith(AppRoute.adminContacts)) return 3;
    if (location.startsWith(AppRoute.adminTracker)) return 4;
    return 0; // dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.admin);
        break;
      case 1:
        context.go(AppRoute.adminCourses);
        break;
      case 2:
        context.go(AppRoute.adminCommunity);
        break;
      case 3:
        context.go(AppRoute.adminContacts);
        break;
      case 4:
        context.go(AppRoute.adminTracker);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);
    final inAdminSettings = location.startsWith(AppRoute.adminSettings);
    // Dynamic title per admin page (hide title on Routine page)
    Widget? appBarTitle;
    if (location.startsWith(AppRoute.adminStudentAdmission)) {
      appBarTitle = const Text('Student Admission');
    } else if (location.startsWith(AppRoute.adminStudentUpdation)) {
      appBarTitle = const Text('Student Updation');
    } else if (location.startsWith(AppRoute.adminTeacherJoining)) {
      appBarTitle = const Text('Teacher Joining');
    } else if (location.startsWith(AppRoute.adminTeacherUpdation)) {
      appBarTitle = const Text('Teacher Updation');
    } else if (location.startsWith(AppRoute.adminUsers)) {
      appBarTitle = const Text('Users');
    } else if (location.startsWith(AppRoute.adminRoutine)) {
      appBarTitle = const Text('Routine');
    } else if (location.startsWith(AppRoute.adminCourses)) {
      appBarTitle = const Text('Courses');
    } else if (location.startsWith(AppRoute.adminCommunity)) {
      appBarTitle = const Text('Community');
    } else if (location.startsWith(AppRoute.adminContacts)) {
      appBarTitle = const Text('Contacts');
    } else if (location.startsWith(AppRoute.adminTracker)) {
      appBarTitle = const Text('Tracker');
    } else if (location.startsWith(AppRoute.adminSettings)) {
      appBarTitle = const Text('Settings');
    } else {
      appBarTitle = const Text('Administrator');
    }

    return Scaffold(
      appBar: inAdminSettings
          ? null
          : AppBar(
              title: appBarTitle,
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
                // Profile avatar with quick actions
                PopupMenuButton<int>(
                  tooltip: 'Profile',
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (context) {
                    final user = Supabase.instance.client.auth.currentUser;
                    if (user == null) {
                      return const [
                        PopupMenuItem(value: 10, child: ListTile(leading: Icon(Icons.login), title: Text('Sign in'))),
                        PopupMenuItem(value: 11, child: ListTile(leading: Icon(Icons.person_add_alt), title: Text('Sign up'))),
                      ];
                    }
                    return const [
                      PopupMenuItem(value: 1, child: ListTile(leading: Icon(Icons.group), title: Text('Users'))),
                      PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.schedule), title: Text('Routine'))),
                      PopupMenuDivider(height: 8),
                      PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.settings), title: Text('Settings'))),
                      PopupMenuItem(value: 4, child: ListTile(leading: Icon(Icons.logout), title: Text('Sign out'))),
                    ];
                  },
                  onSelected: (v) async {
                    // Defer to next frame so popup menu fully disposes before navigating
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      if (v == 10) {
                        context.push(AppRoute.adminSignIn);
                      } else if (v == 11) {
                        context.push(AppRoute.adminSignUp);
                      } else if (v == 1) {
                        context.push(AppRoute.adminUsers);
                      } else if (v == 2) {
                        context.push(AppRoute.adminRoutine);
                      } else if (v == 3) {
                        context.push(AppRoute.adminSettings);
                      } else if (v == 4) {
                        () async {
                          try {
                            await Supabase.instance.client.auth.signOut();
                          } catch (_) {}
                          await LastArea.clear();
                          if (context.mounted) context.go(AppRoute.landing);
                        }();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      drawer: inAdminSettings ? null : const AdminDrawer(),
      body: SafeArea(child: widget.child),
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
