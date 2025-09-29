import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Community',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.group, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome to your study community', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Find friends, form groups, and collaborate on tasks and courses.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _CommunityChip(label: 'My Groups'),
            _CommunityChip(label: 'Classmates'),
            _CommunityChip(label: 'Mentors'),
            _CommunityChip(label: 'Study Rooms'),
          ],
        ),
      ],
    );
  }
}

class _CommunityChip extends StatelessWidget {
  const _CommunityChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.group_outlined, size: 18),
      label: Text(label),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped')),
        );
      },
    );
  }
}
