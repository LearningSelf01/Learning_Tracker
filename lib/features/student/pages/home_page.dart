import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../widgets/app_drawer.dart';
import '../../../core/last_area.dart';
import '../data/student_repository.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _TopNavChip extends StatelessWidget {
  const _TopNavChip({required this.label, required this.icon, required this.route, required this.location});
  final String label;
  final IconData icon;
  final String route;
  final String location;

  bool _selected() => location.startsWith(route);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = _selected();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? cs.onSecondaryContainer : cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: (_) {
          if (!selected) context.go(route);
        },
        showCheckmark: false,
        selectedColor: cs.secondaryContainer,
        backgroundColor: cs.surfaceContainerHighest,
        side: BorderSide(color: cs.outlineVariant),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }

}

class _HomeShellState extends State<HomeShell> {
  // Hidden by default; shown when user taps the profile button
  bool _bannerVisible = false;
  Future<String?>? _titleNameFuture;
  StreamSubscription<AuthState>? _authSub;
  // For anchoring the popup menu to a stable overlay position
  final GlobalKey _profileBtnKey = GlobalKey(debugLabel: 'profile_menu_btn');

  @override
  void initState() {
    super.initState();
    // Remember that user used the student area
    LastArea.setStudent();
    // Preload student data so all pages can access it immediately
    // Ignore result here; pages will use the cached data
    StudentRepository().loadStudentData();
    // Cache the AppBar title lookup and refresh on auth changes
    _titleNameFuture = StudentRepository().fetchStudentFullName();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      if (!mounted) return;
      setState(() {
        _titleNameFuture = StudentRepository().fetchStudentFullName();
      });
    });
  }

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
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isAuthRoute = location.startsWith(AppRoute.signIn) || location.startsWith(AppRoute.signUp);
    final isSettingsRoute = location.startsWith(AppRoute.settings);
    final isProfileRoute = location.startsWith(AppRoute.userProfile);
    // Sub-pages that will provide their own AppBar (with back button)
    final isSubAppBarRoute =
        location.startsWith(AppRoute.courses) ||
        location.startsWith(AppRoute.calendar) ||
        location.startsWith(AppRoute.tasks) ||
        location.startsWith(AppRoute.routing) ||
        location.startsWith(AppRoute.tracker) ||
        location.startsWith(AppRoute.cvMaker) ||
        location.startsWith(AppRoute.skills);
    final user = Supabase.instance.client.auth.currentUser;
    final String? fullName = user?.userMetadata?['full_name'] as String?;
    final bool isLoggedIn = user != null;
    final showBanner = _bannerVisible && !isAuthRoute && !isLoggedIn;

    return Scaffold(
      // Hide AppBar on profile and settings pages per request
      appBar: (isAuthRoute || isProfileRoute || isSettingsRoute || isSubAppBarRoute)
          ? null
          : AppBar(
        title: FutureBuilder<String?>(
          future: _titleNameFuture,
          builder: (context, snap) {
            final repoName = (snap.data ?? '').trim();
            final metaName = (fullName ?? '').trim();
            final name = repoName.isNotEmpty ? repoName : metaName;
            return Text(name.isEmpty ? 'Learning Tracker' : name);
          },
        ),
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
          // Profile avatar: if logged in show popup (anchored to root overlay), else toggle sign-in banner
          if (isLoggedIn)
            Builder(builder: (parentCtx) {
              return IconButton(
                key: _profileBtnKey,
                tooltip: 'Profile',
                onPressed: () async {
                  // Calculate position of the icon button
                  final RenderBox button = _profileBtnKey.currentContext!.findRenderObject() as RenderBox;
                  final overlay = Navigator.of(parentCtx, rootNavigator: true).overlay!;
                  final RenderBox overlayBox = overlay.context.findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlayBox);
                  final RelativeRect position = RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + button.size.height,
                    overlayBox.size.width - offset.dx - button.size.width,
                    overlayBox.size.height - offset.dy,
                  );

                  final selected = await showMenu<int>(
                    context: overlay.context,
                    position: position,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    items: const [
                      PopupMenuItem(value: 1, child: ListTile(leading: Icon(Icons.person), title: Text('Profile'))),
                      PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.settings), title: Text('Settings'))),
                      PopupMenuDivider(height: 8),
                      PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.logout), title: Text('Sign out'))),
                    ],
                  );

                  if (!mounted || selected == null) return;
                  // Defer navigation until popup is fully removed
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (!mounted) return;
                    if (selected == 1) {
                      parentCtx.push(AppRoute.userProfile);
                    } else if (selected == 2) {
                      parentCtx.push(AppRoute.settings);
                    } else if (selected == 3) {
                      try { await Supabase.instance.client.auth.signOut(); } catch (_) {}
                      StudentRepository().clearCache();
                      await LastArea.clear();
                      parentCtx.go(AppRoute.landing);
                    }
                  });
                },
                icon: const Icon(Icons.account_circle_outlined),
              );
            })
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
      drawer: (isAuthRoute || isProfileRoute || isSettingsRoute) ? null : const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            if (showBanner)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Material(
                  color: cs.surfaceContainerHighest,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: cs.outlineVariant),
                    borderRadius: BorderRadius.circular(12),
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
                            context.go(AppRoute.signUp);
                          },
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(width: 4),
                        OutlinedButton(
                          onPressed: () {
                            setState(() => _bannerVisible = false);
                            context.go(AppRoute.signIn);
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
      bottomNavigationBar: (isAuthRoute || isProfileRoute || isSettingsRoute)
          ? null
          : NavigationBar(
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

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
