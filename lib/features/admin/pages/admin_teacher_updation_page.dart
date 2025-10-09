import 'package:flutter/material.dart';

class AdminTeacherUpdationPage extends StatefulWidget {
  const AdminTeacherUpdationPage({super.key});

  @override
  State<AdminTeacherUpdationPage> createState() => _AdminTeacherUpdationPageState();
}

class _AdminTeacherUpdationPageState extends State<AdminTeacherUpdationPage> {
  String _degreeType = 'UG';
  String _degreeProgram = 'BSc';
  String _department = 'Computer Science';
  String _semester = 'Sem 1';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilterRow(
          label: 'Pursuing Degree',
          leftValue: _degreeType,
          leftItems: const ['UG', 'PG', 'Both'],
          rightValue: _degreeProgram,
          rightItems: const ['BSc', 'BTech', 'MSc', 'MTech'],
          onLeftChanged: (v) => setState(() => _degreeType = v!),
          onRightChanged: (v) => setState(() => _degreeProgram = v!),
        ),
        _SingleFilterRow(
          label: 'Department',
          value: _department,
          items: const ['Computer Science', 'Electronics', 'Mechanical'],
          onChanged: (v) => setState(() => _department = v!),
        ),
        _SingleFilterRow(
          label: 'Semester',
          value: _semester,
          items: const ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Sem 5', 'Sem 6', 'Sem 7', 'Sem 8'],
          onChanged: (v) => setState(() => _semester = v!),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 8,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  title: Text('Teacher Update #${index + 1}'),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SingleFilterRow extends StatelessWidget {
  const _SingleFilterRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.leftValue,
    required this.leftItems,
    required this.rightValue,
    required this.rightItems,
    required this.onLeftChanged,
    required this.onRightChanged,
  });

  final String label;
  final String leftValue;
  final List<String> leftItems;
  final String rightValue;
  final List<String> rightItems;
  final ValueChanged<String?> onLeftChanged;
  final ValueChanged<String?> onRightChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: leftValue,
                  isExpanded: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  items: leftItems.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: onLeftChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: rightValue,
                  isExpanded: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  items: rightItems.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: onRightChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
