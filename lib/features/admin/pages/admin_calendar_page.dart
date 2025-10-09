import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';

class AdminCalendarPage extends StatefulWidget {
  const AdminCalendarPage({super.key});

  @override
  State<AdminCalendarPage> createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();
    final first = DateTime(today.year - 1, 1, 1);
    final last = DateTime(today.year + 2, 12, 31);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.pop();
          } else {
            context.go(AppRoute.admin);
          }
        }),
        title: const Text('Calendar'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: cs.primary),
              const SizedBox(width: 8),
              Text('Calendar', style: text.headlineSmall),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: CalendarDatePicker(
              initialDate: _selected,
              firstDate: first,
              lastDate: last,
              onDateChanged: (date) => setState(() => _selected = date),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.event, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected: ${_selected.toLocal().toString().split(' ')[0]}',
                    style: text.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
