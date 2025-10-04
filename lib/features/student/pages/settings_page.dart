import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../../../core/last_area.dart';
import '../data/student_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snap) {
        final user = snap.data?.session?.user ?? Supabase.instance.client.auth.currentUser;

        final tiles = [
          _SettingsTile(
            icon: Icons.person_rounded,
            title: 'Profile Details',
            subtitle: 'Update your name, email and avatar',
            onTap: () => context.push(AppRoute.settingsProfile),
          ),
          _SettingsTile(
            icon: Icons.school_rounded,
            title: 'Student Information',
            subtitle: 'Academic information and identifiers',
            onTap: () => context.push(AppRoute.settingsStudentDetails),
          ),
          _SettingsTile(
            icon: Icons.home_rounded,
            title: 'Address',
            subtitle: 'Residential address details',
            onTap: () => context.push(AppRoute.settingsAddress),
          ),
          _SettingsTile(
            icon: Icons.family_restroom_rounded,
            title: 'Family Details',
            subtitle: 'Guardian and contact information',
            onTap: () => context.push(AppRoute.settingsFamily),
          ),
          _SettingsTile(
            icon: Icons.lock_rounded,
            title: 'Password',
            subtitle: 'Change your account password',
            onTap: () => context.push(AppRoute.settingsPassword),
          ),
          const Divider(height: 0),
          _SettingsTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            subtitle: 'Sign out from this device',
            danger: true,
            onTap: () async {
              // Hard logout: end session and clear cache. Router will redirect after auth changes.
              try {
                await Supabase.instance.client.auth.signOut();
              } catch (_) {}
              StudentRepository().clearCache();
              await LastArea.clear();
              // Do not navigate here; avoid using context during widget disposal.
            },
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                final nav = Navigator.of(context);
                if (nav.canPop()) {
                  nav.pop();
                } else {
                  context.go(AppRoute.dashboard);
                }
              },
            ),
            title: const Text('Settings'),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tiles.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) => tiles[index],
          ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = danger ? cs.error : cs.primary;
    final onColor = danger ? cs.onError : cs.onPrimary;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: TextStyle(color: danger ? cs.error : null)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: onColor.withOpacity(.6)),
    );
  }
}
