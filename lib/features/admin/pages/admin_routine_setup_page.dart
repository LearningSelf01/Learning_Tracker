import 'package:flutter/material.dart';

class AdminRoutineSetupPage extends StatelessWidget {
  const AdminRoutineSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Routine Setup (Admin)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pre-store routine configuration goes here', style: text.titleMedium),
              const SizedBox(height: 8),
              const Text('This is an admin-only placeholder. We can wire it to Supabase later.'),
            ],
          ),
        ),
      ),
    );
  }
}
