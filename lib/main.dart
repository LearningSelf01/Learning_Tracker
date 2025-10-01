import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';

void main() {
  runApp(const ProviderScope(child: LearningTrackerApp()));
}

class LearningTrackerApp extends ConsumerWidget {
  const LearningTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Learning Tracker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
