import 'package:flutter/material.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Skills feature coming soon...'),
        ),
      ),
    );
  }
}
