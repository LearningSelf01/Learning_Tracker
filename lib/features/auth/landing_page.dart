import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Learning Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.dashboard),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Student Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.teacher),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Teacher Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.admin),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Administrator Login'),
            ),
            // Sign out button removed per request; users can sign out from role apps
          ],
        ),
      ),
    );
  }
}
