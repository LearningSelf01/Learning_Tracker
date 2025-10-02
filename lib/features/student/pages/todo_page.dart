import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rounded, size: 48, color: cs.primary),
            const SizedBox(height: 12),
            const Text(
              'To-do page placeholder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'You can provide the data spec later; we\'ll wire it here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
