import 'package:flutter/material.dart';

class TeacherContactsPage extends StatelessWidget {
  const TeacherContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Removed in-body 'Contacts' header (AppBar already provides title)
        Card(
          child: Column(
            children: const [
              _ContactTile(name: 'Alex Johnson', status: 'Online'),
              Divider(height: 0),
              _ContactTile(name: 'Priya Singh', status: 'Last seen 2h ago'),
              Divider(height: 0),
              _ContactTile(name: 'Chen Wei', status: 'Do not disturb'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.name, required this.status});
  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.secondaryContainer,
        child: Icon(Icons.person_outline, color: cs.onSecondaryContainer),
      ),
      title: Text(name),
      subtitle: Text(status, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
      trailing: const Icon(Icons.message_outlined),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open chat with $name')));
      },
    );
  }
}
