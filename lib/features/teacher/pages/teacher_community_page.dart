import 'package:flutter/material.dart';

class TeacherCommunityPage extends StatelessWidget {
  const TeacherCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Chips moved to AppBar bottom; body intentionally left empty
    return const SizedBox.shrink();
  }
}

class _CommunityChip extends StatelessWidget {
  const _CommunityChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.group_outlined, size: 18),
      label: Text(label),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped')),
        );
      },
    );
  }
}
