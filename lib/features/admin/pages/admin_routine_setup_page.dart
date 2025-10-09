import 'package:flutter/material.dart';
import '../../student/data/routine_repository.dart';

class AdminRoutineSetupPage extends StatefulWidget {
  const AdminRoutineSetupPage({super.key});

  @override
  State<AdminRoutineSetupPage> createState() => _AdminRoutineSetupPageState();
}

class _AdminRoutineSetupPageState extends State<AdminRoutineSetupPage> {
  final _repo = const RoutineRepository();

  late final List<DepartmentRoutine> _departments;
  DepartmentRoutine? _dept;
  StreamRoutine? _stream;
  SemesterRoutine? _semester;
  DayOfWeek _day = DayOfWeek.mon;
  String? _overrideRoom;

  // Additional UI-only filters as requested
  String _degreeType = 'UG';
  String _degreeProgram = 'BSc';
  @override
  void initState() {
    super.initState();
    _departments = _repo.fetchAll();
    if (_departments.isNotEmpty) {
      _dept = _departments.first;
      if (_dept!.streams.isNotEmpty) {
        _stream = _dept!.streams.first;
        if (_stream!.semesters.isNotEmpty) {
          _semester = _stream!.semesters.first;
        }
      }
    }
  }

  Future<void> _onAddSubject() async {
    if (_semester == null) return;
    final titleCtrl = TextEditingController();
    final codeCtrl = TextEditingController(text: 'NEW');
    final teacherCtrl = TextEditingController(text: 'TBD');
    final roomCtrl = TextEditingController();
    TimeOfDay? start;
    TimeOfDay? end;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Code')),
                const SizedBox(height: 8),
                TextField(controller: teacherCtrl, decoration: const InputDecoration(labelText: 'Teacher')),
                const SizedBox(height: 8),
                TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room (optional)')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                          if (picked != null) {
                            start = picked;
                          }
                        },
                        child: Text(start == null ? 'Pick start' : 'Start ${_fmt(start!)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
                          if (picked != null) {
                            end = picked;
                          }
                        },
                        child: Text(end == null ? 'Pick end' : 'End ${_fmt(end!)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                start ??= const TimeOfDay(hour: 9, minute: 0);
                end ??= const TimeOfDay(hour: 9, minute: 50);
                final subject = Subject(code: codeCtrl.text.trim(), title: titleCtrl.text.trim(), teacher: teacherCtrl.text.trim(), defaultRoom: roomCtrl.text.trim().isEmpty ? null : roomCtrl.text.trim());
                final period = Period(start: start!, end: end!, subject: subject);
                setState(() {
                  final list = _semester!.weekly[_day] ?? <Period>[];
                  list.add(period);
                  _semester!.weekly[_day] = list;
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final periods = (_semester?.weekly[_day] ?? const <Period>[]);

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pursuing Degree row (two dropdowns side-by-side)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pursuing Degree', style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _degreeType,
                          isExpanded: true,
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                          items: const ['UG', 'PG']
                              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _degreeType = v ?? 'UG'),
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
                          onChanged: (v) => setState(() => _degreeProgram = v ?? 'BSc'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Department and Semester in the same row
            Row(
              children: [
                Expanded(
                  child: _LabeledDropdown<DepartmentRoutine>(
                    label: 'Department',
                    value: _dept,
                    items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
                    onChanged: (v) => setState(() {
                      _dept = v;
                      _stream = v?.streams.isNotEmpty == true ? v!.streams.first : null;
                      _semester = _stream?.semesters.isNotEmpty == true ? _stream!.semesters.first : null;
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LabeledDropdown<SemesterRoutine>(
                    label: 'Semester',
                    value: (_stream?.semesters ?? const <SemesterRoutine>[]).contains(_semester) ? _semester : null,
                    items: (_stream?.semesters ?? const <SemesterRoutine>[]) 
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _semester = v),
                  ),
                ),
              ],
            ),
            // Day selector as chips (Mon-Fri)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day', style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final d in const [DayOfWeek.mon, DayOfWeek.tue, DayOfWeek.wed, DayOfWeek.thu, DayOfWeek.fri])
                        ChoiceChip(
                          label: Text(dayLabel(d)),
                          selected: _day == d,
                          onSelected: (_) => setState(() => _day = d),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 0),
            const SizedBox(height: 12),
            Expanded(
              child: periods.isEmpty
                  ? Center(child: Text('No classes scheduled', style: text.bodyLarge?.copyWith(color: cs.onSurfaceVariant)))
                  : ListView.separated(
                      itemCount: periods.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = periods[i];
                        final defaultRoom = p.subject.defaultRoom;
                        return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: cs.outlineVariant)),
                          title: Text(p.subject.title),
                          subtitle: Text('${p.subject.code} • ${p.subject.teacher}${defaultRoom == null ? '' : ' • Room $defaultRoom'}'),
                          trailing: Text('${_fmt(p.start)} - ${_fmt(p.end)}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add subject',
        onPressed: _onAddSubject,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ap';
  }

  // Reusable labeled dropdown styled like student pages
  // ignore: unused_element
  Widget _buildDeptDropdown(BuildContext context) => const SizedBox.shrink();
  // ignore: unused_element
  Widget _buildStreamDropdown(BuildContext context) => const SizedBox.shrink();
  // ignore: unused_element
  Widget _buildSemesterDropdown(BuildContext context) => const SizedBox.shrink();
}

class _LabeledDropdown<T> extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
