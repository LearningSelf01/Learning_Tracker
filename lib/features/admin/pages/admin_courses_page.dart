import 'package:flutter/material.dart';

class AdminCoursesPage extends StatefulWidget {
  const AdminCoursesPage({super.key});

  @override
  State<AdminCoursesPage> createState() => _AdminCoursesPageState();
}

class _AdminCoursesPageState extends State<AdminCoursesPage> {
  String _degreeType = 'UG';
  String _degreeProgram = 'BSc';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
