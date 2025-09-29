import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.assignment, color: cs.primary),
            const SizedBox(width: 8),
            Text('Tasks', style: text.headlineSmall),
          ],
        ),
        const SizedBox(height: 12),

        // Filters
        Wrap(
          spacing: 8,
          children: const [
            _FilterChip(label: 'All', selected: true),
            _FilterChip(label: 'Due Today'),
            _FilterChip(label: 'Completed'),
          ],
        ),

        const SizedBox(height: 12),

        // Task cards
        const _TaskCard(title: 'Math Assignment', subtitle: 'Problem Set 3', due: 'Today, 6 PM', status: _TaskStatus.due),
        const _TaskCard(title: 'Physics Lab Report', subtitle: 'Experiment 5', due: 'Tomorrow', status: _TaskStatus.upcoming),
        const _TaskCard(title: 'CS Project', subtitle: 'Implement Linked List', due: 'Fri', status: _TaskStatus.inProgress),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.primary.withOpacity(0.12) : cs.surface;
    final borderColor = selected ? cs.primary : cs.outlineVariant;
    final fg = selected ? cs.primary : cs.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg)),
    );
  }
}

enum _TaskStatus { due, inProgress, upcoming }

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.title, required this.subtitle, required this.due, required this.status});
  final String title;
  final String subtitle;
  final String due;
  final _TaskStatus status;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Color colorFor(_TaskStatus s) {
      switch (s) {
        case _TaskStatus.due:
          return cs.error;
        case _TaskStatus.inProgress:
          return cs.primary;
        case _TaskStatus.upcoming:
          return cs.secondary;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: status == _TaskStatus.inProgress && false, // placeholder; you can wire state later
            onChanged: (_) {},
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(due, style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorFor(status).withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colorFor(status)),
            ),
            child: Text(
              status == _TaskStatus.due
                  ? 'Due'
                  : status == _TaskStatus.inProgress
                      ? 'In Progress'
                      : 'Upcoming',
              style: text.labelLarge?.copyWith(color: colorFor(status), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
