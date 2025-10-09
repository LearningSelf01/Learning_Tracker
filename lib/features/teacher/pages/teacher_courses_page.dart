import 'package:flutter/material.dart';

class TeacherCoursesPage extends StatefulWidget {
  const TeacherCoursesPage({super.key});

  @override
  State<TeacherCoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<TeacherCoursesPage> {
  String _degreeType = 'UG';
  String _degreeProgram = 'BSc';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pursuing Degree filters
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text('Pursuing Degree', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _degreeType,
                  isExpanded: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  items: const ['UG', 'PG', 'Both']
                      .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _degreeType = v ?? _degreeType),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _degreeProgram,
                  isExpanded: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  items: const ['BSc', 'BTech', 'MSc', 'MTech']
                      .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _degreeProgram = v ?? _degreeProgram),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 12,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.menu_book)),
                title: Text('Course #${index + 1}'),
                subtitle: Text('$_degreeType · $_degreeProgram'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: cs.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.title, required this.subtitle, required this.progress});
  final String title;
  final String subtitle;
  final double progress;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: cs.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.menu_book, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              _ProgressPill(progress: progress),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: cs.primary,
              backgroundColor: cs.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary),
      ),
      child: Text('$pct%', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
    );
  }
}
