import 'package:flutter/material.dart';

class RoutingPage extends StatelessWidget {
  const RoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(Icons.route, color: cs.primary),
            const SizedBox(width: 8),
            Text('Routing', style: text.headlineSmall),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            for (final d in const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'])
              _FilterChip(label: d, selected: d == 'Mon'),
          ],
        ),
        const SizedBox(height: 12),
        const _ScheduleCard(course: 'Mathematics', subtitle: 'Lecture • Room 101', time: '9:00 AM - 10:00 AM'),
        const _ScheduleCard(course: 'Physics', subtitle: 'Lab • Room B2', time: '11:00 AM - 12:30 PM'),
        const _ScheduleCard(course: 'Computer Science', subtitle: 'Tutorial • Lab 3', time: '2:00 PM - 3:00 PM'),
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

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.course, required this.subtitle, required this.time});
  final String course;
  final String subtitle;
  final String time;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Text(time, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
