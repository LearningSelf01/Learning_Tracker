import 'package:flutter/material.dart';

class TeacherSettingsPasswordPage extends StatelessWidget {
  const TeacherSettingsPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Change Password')),
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
