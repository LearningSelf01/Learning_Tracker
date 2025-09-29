import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(Icons.people_alt, color: cs.primary),
            const SizedBox(width: 8),
            Text('Contacts', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: cs.primaryContainer, child: Icon(Icons.person, color: cs.onPrimaryContainer)),
            title: const Text('Invite friends'),
            subtitle: const Text('Send an invite to collaborate on tasks and courses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite friends tapped')));
            },
          ),
        ),
        const SizedBox(height: 8),
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
