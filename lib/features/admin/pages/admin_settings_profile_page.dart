import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';

class AdminSettingsProfilePage extends StatelessWidget {
  const AdminSettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              context.go(AppRoute.admin);
            }
          },
        ),
        title: const Text('Profile Details'),
      ),
      body: const Center(child: Text('Admin profile settings go here.')),
    );
  }
}
