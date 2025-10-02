import 'package:flutter/material.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, i) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text('User #${i + 1}'),
        subtitle: const Text('role: student'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: 20,
    );
  }
}
