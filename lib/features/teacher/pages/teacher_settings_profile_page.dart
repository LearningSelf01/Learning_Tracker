import 'package:flutter/material.dart';

class TeacherSettingsProfilePage extends StatelessWidget {
  const TeacherSettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Profile Details')),
      body: const Center(child: Text('Teacher profile settings go here.')),
    );
  }
}
