import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app_router.dart';
import '../../../core/last_area.dart';

class TeacherSettingsPage extends StatelessWidget {
  const TeacherSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Profile Details'),
            subtitle: const Text('Update your name, email and avatar'),
            onTap: () => context.push(AppRoute.teacherSettingsProfile),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.lock)),
            title: const Text('Password'),
            subtitle: const Text('Change your account password'),
            onTap: () => context.push(AppRoute.teacherSettingsPassword),
          ),
          const Divider(height: 0),
          ListTile(
            leading: CircleAvatar(backgroundColor: cs.error.withOpacity(.15), child: Icon(Icons.logout, color: cs.error)),
            title: Text('Sign out', style: TextStyle(color: cs.error)),
            subtitle: const Text('Sign out from this device'),
            onTap: () async {
              try { await Supabase.instance.client.auth.signOut(); } catch (_) {}
              await LastArea.clear();
              // Do not navigate; router will redirect after auth state change.
            },
          ),
        ],
      ),
    );
  }
}
