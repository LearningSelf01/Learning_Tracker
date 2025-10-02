import 'package:flutter/material.dart';
import '../../student/data/routine_repository.dart';

class AdminRoomOverridePage extends StatefulWidget {
  const AdminRoomOverridePage({super.key});

  @override
  State<AdminRoomOverridePage> createState() => _AdminRoomOverridePageState();
}

class _AdminRoomOverridePageState extends State<AdminRoomOverridePage> {
  final _repo = const RoutineRepository();

  late final List<DepartmentRoutine> _departments;
  DepartmentRoutine? _dept;
  StreamRoutine? _stream;
  SemesterRoutine? _semester;
  DayOfWeek _day = DayOfWeek.mon;
  String? _overrideRoom;

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final periods = (_semester?.weekly[_day] ?? const <Period>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Room Override (Admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select target class', style: text.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDeptDropdown(context),
                _buildStreamDropdown(context),
                _buildSemesterDropdown(context),
                DropdownButton<DayOfWeek>(
                  value: _day,
                  onChanged: (v) => setState(() => _day = v ?? DayOfWeek.mon),
                  items: [for (final d in const [DayOfWeek.mon, DayOfWeek.tue, DayOfWeek.wed, DayOfWeek.thu, DayOfWeek.fri]) DropdownMenuItem(value: d, child: Text(dayLabel(d)))],
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Override Room (for selected day only)', border: OutlineInputBorder()),
              onChanged: (v) => _overrideRoom = v,
            ),
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
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_overrideRoom == null || _overrideRoom!.isEmpty ? 'Cleared override for this period (not persisted)' : 'Set override room to $_overrideRoom (not persisted)')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ap';
  }

  Widget _buildDeptDropdown(BuildContext context) {
    return DropdownButton<DepartmentRoutine>(
      value: _dept,
      hint: const Text('Department'),
      items: [for (final d in _departments) DropdownMenuItem(value: d, child: Text(d.name))],
      onChanged: (v) => setState(() {
        _dept = v;
        _stream = v?.streams.isNotEmpty == true ? v!.streams.first : null;
        _semester = _stream?.semesters.isNotEmpty == true ? _stream!.semesters.first : null;
      }),
    );
  }

  Widget _buildStreamDropdown(BuildContext context) {
    final streams = _dept?.streams ?? const <StreamRoutine>[];
    return DropdownButton<StreamRoutine>(
      value: streams.contains(_stream) ? _stream : null,
      hint: const Text('Stream'),
      items: [for (final s in streams) DropdownMenuItem(value: s, child: Text(s.name))],
      onChanged: (v) => setState(() {
        _stream = v;
        _semester = v?.semesters.isNotEmpty == true ? v!.semesters.first : null;
      }),
    );
  }

  Widget _buildSemesterDropdown(BuildContext context) {
    final semesters = _stream?.semesters ?? const <SemesterRoutine>[];
    return DropdownButton<SemesterRoutine>(
      value: semesters.contains(_semester) ? _semester : null,
      hint: const Text('Semester'),
      items: [for (final s in semesters) DropdownMenuItem(value: s, child: Text(s.name))],
      onChanged: (v) => setState(() => _semester = v),
    );
  }
}
