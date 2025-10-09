import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading removed per request
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(color: cs.primaryContainer, label: 'Total Users', value: '—'),
              _StatCard(color: cs.secondaryContainer, label: 'Active Today', value: '—'),
              _StatCard(color: cs.tertiaryContainer, label: 'Reports', value: '—'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                'Welcome, Administrator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSecondaryContainer;
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: on)),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: on)),
      ]),
    );
  }
}
