import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_router.dart';
import 'core/last_area.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LastArea.init();
  await Supabase.initialize(
    url: 'https://cdopnezysniybozjwwcg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNkb3BuZXp5c25peWJvemp3d2NnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMjA0MjAsImV4cCI6MjA3NDg5NjQyMH0.KB5xfyBNcubCksC9bwlKQLvZOPzNALy0UHpQd9B3pXE',
  );
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
