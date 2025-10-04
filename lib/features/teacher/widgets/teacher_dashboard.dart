import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    // Show a static Teacher name to avoid leaking student identity.
    // TODO: Replace with teacher-specific client when multi-app auth is wired.
    final displayName = 'Teacher';

    final bottomInset = MediaQuery.of(context).padding.bottom;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomInset + kBottomNavigationBarHeight),
      children: [
        _WelcomeCard(
          userName: displayName,
          onCreateClass: () {},
          onViewSchedule: () {},
        ),
        const SizedBox(height: 12),
        // Quick stats
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const [
                _StatCard(icon: Icons.class_, label: 'Today\'s Classes', value: '3'),
                _StatCard(icon: Icons.assignment_turned_in, label: 'Assignments', value: '6'),
                _StatCard(icon: Icons.group, label: 'Students', value: '120'),
                _StatCard(icon: Icons.analytics, label: 'Reports', value: '2'),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        // Schedule section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today\'s Schedule", style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.chevron_right), label: const Text('View All')),
          ],
        ),
        const _ScheduleCard(
          course: 'Linear Algebra',
          subtitle: 'MTH201 • Room 204',
          time: '9:00 AM',
          statusLabel: 'Ongoing',
          statusColorKey: _StatusColorKey.active,
        ),
        const _ScheduleCard(
          course: 'Quantum Mechanics',
          subtitle: 'PHY305 • Lab 2',
          time: '11:00 AM',
          statusLabel: 'Assignment Due',
          statusColorKey: _StatusColorKey.info,
        ),
        const _ScheduleCard(
          course: 'Data Structures',
          subtitle: 'CS210 • Lab 3',
          time: '2:00 PM',
          statusLabel: 'Upcoming',
          statusColorKey: _StatusColorKey.neutral,
        ),
        const SizedBox(height: 8),
        Text('Quick Actions', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        Text('Jump to your common tasks', style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        const _QuickActionTile(icon: Icons.event_note, title: 'View Schedule', subtitle: 'Today\'s Classes'),
        const _QuickActionTile(icon: Icons.assignment, title: 'Grade Assignments', subtitle: 'Pending Submissions'),
        const _QuickActionTile(icon: Icons.analytics_outlined, title: 'Class Analytics', subtitle: 'Performance Overview'),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: cs.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.userName, required this.onCreateClass, required this.onViewSchedule});
  final String userName;
  final VoidCallback onCreateClass;
  final VoidCallback onViewSchedule;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [cs.surface, cs.surfaceContainerHighest.withOpacity(0.85)]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back, $userName! 👋', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text('Ready for today\'s classes?', style: text.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _ChipButton(icon: Icons.add_circle, label: 'Create Class', onTap: onCreateClass),
              _ChipButton(icon: Icons.event_note, label: 'View Schedule', onTap: onViewSchedule),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outlineVariant)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: cs.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(height: 12),
          Text(value, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

enum _StatusColorKey { active, info, neutral }

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.course, required this.subtitle, required this.time, required this.statusLabel, this.statusColorKey = _StatusColorKey.neutral});
  final String course;
  final String subtitle;
  final String time;
  final String statusLabel;
  final _StatusColorKey statusColorKey;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Color badgeColor() {
      switch (statusColorKey) {
        case _StatusColorKey.active:
          return cs.primary;
        case _StatusColorKey.info:
          return cs.secondary;
        case _StatusColorKey.neutral:
          return cs.surfaceContainerHighest;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: cs.outlineVariant)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(width: 8, height: 16, decoration: BoxDecoration(color: badgeColor(), borderRadius: BorderRadius.circular(4))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(course, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: badgeColor().withOpacity(0.12), borderRadius: BorderRadius.circular(999), border: Border.all(color: badgeColor())),
                child: Text(statusLabel, style: text.labelLarge?.copyWith(color: badgeColor(), fontWeight: FontWeight.w600)),
              )
            ]),
          ),
          const SizedBox(width: 12),
          Text(time, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
