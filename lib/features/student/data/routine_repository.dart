import 'package:flutter/material.dart';

class DepartmentRoutine {
  final String id;
  final String name;
  final List<StreamRoutine> streams;
  const DepartmentRoutine({required this.id, required this.name, required this.streams});
}

class StreamRoutine {
  final String id;
  final String name;
  final List<SemesterRoutine> semesters;
  const StreamRoutine({required this.id, required this.name, required this.semesters});
}

class SemesterRoutine {
  final String id;
  final String name; // e.g., "Semester 1"
  final List<Subject> subjects;
  final Map<DayOfWeek, List<Period>> weekly;
  const SemesterRoutine({
    required this.id,
    required this.name,
    required this.subjects,
    required this.weekly,
  });

  /// Factory to build a semester routine from time rules.
  factory SemesterRoutine.fromRules({
    required String id,
    required String name,
    required List<Subject> subjects,
    required SemesterTimeRules rules,
  }) {
    final weekly = <DayOfWeek, List<Period>>{};
    for (final day in DayOfWeek.values) {
      // Only generate for weekdays by default; weekends empty
      final isWeekend = day == DayOfWeek.sat || day == DayOfWeek.sun;
      if (isWeekend && !rules.includeWeekends) {
        weekly[day] = const [];
        continue;
      }

      final dayRule = rules.dayOverrides[day];
      final start = dayRule?.start ?? rules.defaultStart;
      final duration = dayRule?.durationMinutes ?? rules.defaultDurationMinutes;
      final count = dayRule?.slotsCount ?? rules.defaultSlotsCount;

      final slots = <Period>[];
      TimeOfDay cursor = start;
      for (int i = 0; i < count; i++) {
        final subject = subjects[i % subjects.length];
        final end = _addMinutes(cursor, duration);
        slots.add(Period(start: cursor, end: end, subject: subject));
        cursor = _addMinutes(end, rules.intervalBetweenSlotsMinutes);
      }

      // Append any custom blocks (e.g., very long lab session)
      if (dayRule?.customBlocks.isNotEmpty == true) {
        for (final b in dayRule!.customBlocks) {
          final end = _addMinutes(b.start, b.durationMinutes);
          slots.add(Period(start: b.start, end: end, subject: b.subject, room: b.room));
        }
        // Sort by start time
        slots.sort((a, b) => (a.start.hour * 60 + a.start.minute).compareTo(b.start.hour * 60 + b.start.minute));
      }

      weekly[day] = slots;
    }

    return SemesterRoutine(id: id, name: name, subjects: subjects, weekly: weekly);
  }
}

class Subject {
  final String code;
  final String title;
  final String teacher;
  final String? defaultRoom;
  const Subject({required this.code, required this.title, required this.teacher, this.defaultRoom});
}

class Period {
  final TimeOfDay start;
  final TimeOfDay end;
  final Subject subject;
  final String? room;
  const Period({required this.start, required this.end, required this.subject, this.room});
}

enum DayOfWeek { mon, tue, wed, thu, fri, sat, sun }

String dayLabel(DayOfWeek d) {
  switch (d) {
    case DayOfWeek.mon:
      return 'Mon';
    case DayOfWeek.tue:
      return 'Tue';
    case DayOfWeek.wed:
      return 'Wed';
    case DayOfWeek.thu:
      return 'Thu';
    case DayOfWeek.fri:
      return 'Fri';
    case DayOfWeek.sat:
      return 'Sat';
    case DayOfWeek.sun:
      return 'Sun';
  }
}

/// Rules to generate a weekly timetable for a semester.
class SemesterTimeRules {
  final TimeOfDay defaultStart;
  final int defaultDurationMinutes;
  final int defaultSlotsCount;
  final int intervalBetweenSlotsMinutes;
  final bool includeWeekends;
  final Map<DayOfWeek, DayTimeRule> dayOverrides;

  const SemesterTimeRules({
    required this.defaultStart,
    required this.defaultDurationMinutes,
    required this.defaultSlotsCount,
    this.intervalBetweenSlotsMinutes = 10,
    this.includeWeekends = false,
    this.dayOverrides = const {},
  });
}

class DayTimeRule {
  final TimeOfDay? start;
  final int? durationMinutes;
  final int? slotsCount;
  final List<CustomBlock> customBlocks;

  const DayTimeRule({
    this.start,
    this.durationMinutes,
    this.slotsCount,
    this.customBlocks = const [],
  });
}

class CustomBlock {
  final TimeOfDay start;
  final int durationMinutes;
  final Subject subject;
  final String? room;

  const CustomBlock({required this.start, required this.durationMinutes, required this.subject, this.room});
}

TimeOfDay _addMinutes(TimeOfDay t, int minutes) {
  final total = t.hour * 60 + t.minute + minutes;
  final h = (total ~/ 60) % 24;
  final m = total % 60;
  return TimeOfDay(hour: h, minute: m);
}

class RoutineRepository {
  // In a real app this might fetch from Supabase; here we provide mock data.
  const RoutineRepository();

  List<DepartmentRoutine> fetchAll() {
    // Subjects common samples (with teacher and default room)
    const sMath = Subject(code: 'MTH101', title: 'Calculus I', teacher: 'Dr. Allen', defaultRoom: 'A101');
    const sPhy = Subject(code: 'PHY101', title: 'Physics I', teacher: 'Prof. Baker', defaultRoom: 'B204');
    const sCs  = Subject(code: 'CSE101', title: 'Intro to Programming', teacher: 'Ms. Clark', defaultRoom: 'Lab-1');
    const sChem= Subject(code: 'CHM101', title: 'Chemistry I', teacher: 'Dr. Diaz', defaultRoom: 'C103');
    const sDs  = Subject(code: 'CSE201', title: 'Data Structures', teacher: 'Mr. Evans', defaultRoom: 'Lab-2');

    // CS Semester 1: classes start at 11:00, 30-minute duration, weekday schedule
    final rulesSem1 = SemesterTimeRules(
      defaultStart: const TimeOfDay(hour: 11, minute: 0),
      defaultDurationMinutes: 30,
      defaultSlotsCount: 3,
      intervalBetweenSlotsMinutes: 10,
      includeWeekends: false,
      dayOverrides: {
        // Example: Thursday long lab of 2h 30m (150 minutes)
        DayOfWeek.thu: DayTimeRule(
          customBlocks: const [
            CustomBlock(
              start: TimeOfDay(hour: 13, minute: 0),
              durationMinutes: 150,
              subject: sCs,
              room: 'Lab-1',
            ),
          ],
        ),
      },
    );
    final sem1CSE = SemesterRoutine.fromRules(
      id: 'cse-sem1',
      name: 'Semester 1',
      subjects: const [sMath, sPhy, sCs, sChem],
      rules: rulesSem1,
    );

    // CS Semester 3: classes start at 10:00, 50-minute duration
    final rulesSem3 = SemesterTimeRules(
      defaultStart: const TimeOfDay(hour: 10, minute: 0),
      defaultDurationMinutes: 50,
      defaultSlotsCount: 3,
      intervalBetweenSlotsMinutes: 10,
      includeWeekends: false,
    );
    final sem3CSE = SemesterRoutine.fromRules(
      id: 'cse-sem3',
      name: 'Semester 3',
      subjects: const [sDs, sMath, sPhy],
      rules: rulesSem3,
    );

    final cseStreamUG = StreamRoutine(id: 'cse-ug', name: 'CSE - UG', semesters: [sem1CSE, sem3CSE]);
    final cseStreamAI = StreamRoutine(id: 'cse-ai', name: 'CSE - AI', semesters: [sem1CSE]);

    final deptCSE = DepartmentRoutine(id: 'dept-cse', name: 'Computer Science', streams: [cseStreamUG, cseStreamAI]);

    // Another department example
    final eeeRulesSem1 = SemesterTimeRules(
      defaultStart: const TimeOfDay(hour: 9, minute: 30),
      defaultDurationMinutes: 45,
      defaultSlotsCount: 2,
    );
    final sem1EEE = SemesterRoutine.fromRules(
      id: 'eee-sem1',
      name: 'Semester 1',
      subjects: const [sMath, sPhy, sChem],
      rules: eeeRulesSem1,
    );

    final eeeUG = StreamRoutine(id: 'eee-ug', name: 'EEE - UG', semesters: [sem1EEE]);
    final deptEEE = DepartmentRoutine(id: 'dept-eee', name: 'Electrical & Electronics', streams: [eeeUG]);

    return [deptCSE, deptEEE];
  }
}
