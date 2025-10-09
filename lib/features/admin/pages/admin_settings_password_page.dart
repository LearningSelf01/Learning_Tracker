import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';

class AdminSettingsPasswordPage extends StatelessWidget {
  const AdminSettingsPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              context.go(AppRoute.admin);
            }
          },
        ),
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Current Password')),
            SizedBox(height: 12),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'New Password')),
            SizedBox(height: 12),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirm New Password')),
          ],
        ),
      ),
    );
  }
}
