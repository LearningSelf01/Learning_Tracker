import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';

class CvMakerPage extends StatelessWidget {
  const CvMakerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
        title: const Text('Pursuing'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: const SafeArea(
        child: Center(
          child: Text('CV Maker coming soon...'),
        ),
      ),
    );
  }
}
