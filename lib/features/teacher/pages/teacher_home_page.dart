import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../widgets/teacher_drawer.dart';
import '../../../core/last_area.dart';

class TeacherHomeShell extends StatefulWidget {
  const TeacherHomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<TeacherHomeShell> createState() => _TeacherHomeShellState();
}

class _TeacherHomeShellState extends State<TeacherHomeShell> {
  // Hidden by default; shown when user taps the profile button
  bool _bannerVisible = false;

  @override
  void initState() {
    super.initState();
    // Remember that user used the teacher area
    LastArea.setTeacher();
  }
  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoute.teacherCourses)) return 1;
    if (location.startsWith(AppRoute.teacherCommunity)) return 2;
    if (location.startsWith(AppRoute.teacherContacts)) return 3;
    if (location.startsWith(AppRoute.teacherTracker)) return 4;
    return 0; // dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.teacher);
        break;
      case 1:
        context.go(AppRoute.teacherCourses);
        break;
      case 2:
        context.go(AppRoute.teacherCommunity);
        break;
      case 3:
        context.go(AppRoute.teacherContacts);
        break;
      case 4:
        context.go(AppRoute.teacherTracker);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);
    final onAuthScreens =
        location.startsWith(AppRoute.teacherSignIn) || location.startsWith(AppRoute.teacherSignUp);
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final user = Supabase.instance.client.auth.currentUser;
    final bool isLoggedIn = user != null;

    return Scaffold(
      appBar: onAuthScreens
          ? null
          : AppBar(
              title: const Text('Teacher Dashboard'),
              actions: [
                if (!isLoggedIn) ...[
                  TextButton(
                    onPressed: () => context.go(AppRoute.teacherSignUp),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoute.teacherSignIn),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
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
                if (isLoggedIn)
                  PopupMenuButton<int>(
                    tooltip: 'Profile',
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 1, child: ListTile(leading: Icon(Icons.person), title: Text('Profile'))),
                      PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.settings), title: Text('Settings'))),
                      PopupMenuDivider(height: 8),
                      PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.logout), title: Text('Sign out'))),
                    ],
                    onSelected: (v) async {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (!context.mounted) return;
                        if (v == 1) {
                          context.push(AppRoute.teacherSettingsProfile);
                        } else if (v == 2) {
                          context.push(AppRoute.teacherSettings);
                        } else if (v == 3) {
                          try { await Supabase.instance.client.auth.signOut(); } catch (_) {}
                          await LastArea.clear();
                          if (context.mounted) context.go(AppRoute.landing);
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
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() => _bannerVisible = !_bannerVisible),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Tooltip(
                        message: 'Profile',
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
                  ),
              ],
            ),
      drawer: const TeacherDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            if (_bannerVisible && !onAuthScreens)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Material(
                  color: cs.surfaceContainerHighest,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: cs.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.login, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get started',
                                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Start with sign up or sign in',
                                style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _bannerVisible = false);
                            context.go(AppRoute.teacherSignUp);
                          },
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(width: 4),
                        OutlinedButton(
                          onPressed: () {
                            setState(() => _bannerVisible = false);
                            context.go(AppRoute.teacherSignIn);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: cs.primary),
                            foregroundColor: cs.primary,
                          ),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(child: widget.child),
          ],
        ),
      ),
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
