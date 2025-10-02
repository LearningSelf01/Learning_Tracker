import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';
import '../data/routine_repository.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  final RoutineRepository _repo = const RoutineRepository();

  late final List<DepartmentRoutine> _departments;
  DepartmentRoutine? _dept;
  StreamRoutine? _stream;
  SemesterRoutine? _semester;
  DayOfWeek _day = DayOfWeek.mon;
  List<DayOfWeek> get _weekdays => const [
        DayOfWeek.mon,
        DayOfWeek.tue,
        DayOfWeek.wed,
        DayOfWeek.thu,
        DayOfWeek.fri,
      ];

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
    // Ensure default selected day is a weekday
    if (!_weekdays.contains(_day)) {
      _day = DayOfWeek.mon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final periods = (_semester?.weekly[_day] ?? const <Period>[]);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.pop();
          } else {
            context.go(AppRoute.dashboard);
          }
        }),
        title: const Text('Routine'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_view, color: cs.primary),
                const SizedBox(width: 8),
                Text('Routine Table', style: text.headlineSmall),
              ],
            ),
            const SizedBox(height: 12),
            // Selectors row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDeptDropdown(context),
                _buildStreamDropdown(context),
                _buildSemesterDropdown(context),
              ],
            ),
            const SizedBox(height: 12),
            // Day selector
            Wrap(
              spacing: 8,
              children: [
                for (final d in _weekdays)
                  ChoiceChip(
                    label: Text(dayLabel(d)),
                    selected: _day == d,
                    onSelected: (_) => setState(() => _day = d),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Periods list
            Expanded(
              child: periods.isEmpty
                  ? Center(
                      child: Text('No classes scheduled', style: text.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                    )
                  : ListView.separated(
                      itemCount: periods.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final p = periods[index];
                        return _PeriodTile(period: p);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptDropdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<DepartmentRoutine>(
          value: _dept,
          hint: const Text('Department'),
          items: [
            for (final d in _departments)
              DropdownMenuItem(value: d, child: Text(d.name)),
          ],
          onChanged: (v) {
            setState(() {
              _dept = v;
              _stream = v?.streams.isNotEmpty == true ? v!.streams.first : null;
              _semester = _stream?.semesters.isNotEmpty == true ? _stream!.semesters.first : null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildStreamDropdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final streams = _dept?.streams ?? const <StreamRoutine>[];
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<StreamRoutine>(
          value: streams.contains(_stream) ? _stream : null,
          hint: const Text('Stream'),
          items: [
            for (final s in streams)
              DropdownMenuItem(value: s, child: Text(s.name)),
          ],
          onChanged: (v) {
            setState(() {
              _stream = v;
              _semester = v?.semesters.isNotEmpty == true ? v!.semesters.first : null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSemesterDropdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semesters = _stream?.semesters ?? const <SemesterRoutine>[];
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<SemesterRoutine>(
          value: semesters.contains(_semester) ? _semester : null,
          hint: const Text('Semester'),
          items: [
            for (final s in semesters)
              DropdownMenuItem(value: s, child: Text(s.name)),
          ],
          onChanged: (v) {
            setState(() {
              _semester = v;
            });
          },
        ),
      ),
    );
  }
}

class _PeriodTile extends StatelessWidget {
  const _PeriodTile({required this.period});
  final Period period;

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ap';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(period.subject.title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Builder(builder: (context) {
                  final defaultRoom = period.subject.defaultRoom;
                  final overrideRoom = period.room;
                  final hasOverride =
                      overrideRoom != null && overrideRoom.isNotEmpty && overrideRoom != defaultRoom;
                  // First line: CODE • Room <default>, strike-through if overridden
                  if (!hasOverride) {
                    final room = overrideRoom ?? defaultRoom;
                    final parts = <String>[
                      period.subject.code,
                      if (room != null && room.isNotEmpty) 'Room $room',
                    ];
                    return Text(
                      parts.join(' • '),
                      style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    );
                  }
                  // With override: show default room struck-through
                  return RichText(
                    text: TextSpan(
                      style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      children: [
                        TextSpan(text: period.subject.code),
                        const TextSpan(text: ' • '),
                        TextSpan(
                          text: 'Room ${defaultRoom ?? ''}'.trim(),
                          style: text.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Builder(builder: (context) {
                  final overrideRoom = period.room;
                  final defaultRoom = period.subject.defaultRoom;
                  final hasOverride =
                      overrideRoom != null && overrideRoom.isNotEmpty && overrideRoom != defaultRoom;
                  final parts = <String>[
                    period.subject.teacher,
                    if (hasOverride) 'Room $overrideRoom',
                  ];
                  return Text(
                    parts.join(' • '),
                    style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  );
                }),
              ],
            ),
          ),
          Text('${_fmt(period.start)} - ${_fmt(period.end)}', style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
