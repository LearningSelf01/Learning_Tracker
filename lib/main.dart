import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_router.dart';
import 'core/last_area.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LastArea.init();
  // Guard against re-initialization on hot restart
  // Hot restart re-runs main(); initializing Supabase repeatedly can hang.
  // Keep a static flag in the isolate to ensure it runs only once.
  // ignore: prefer_const_declarations
  const _supabaseInitedKey = '_app_supabase_inited';
  // Use Dart's Zone to store a flag across hot restarts in the same VM when possible.
  // Fallback to a static that survives within this isolate instance.
  // Since we cannot depend on Zone here reliably, try-catch to avoid double init exceptions.
  try {
    // If the client is already available, skip.
    // Accessing instance.client before init may throw; hence wrap in try.
    // If no throw and url is non-empty, we assume it's initialized.
    final existing = Supabase.instance.client;
    // If we reached here without throwing, do nothing.
    // ignore: unused_local_variable
    final _ = existing.auth;
  } catch (_) {
    await Supabase.initialize(
      url: 'https://cdopnezysniybozjwwcg.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNkb3BuZXp5c25peWJvemp3d2NnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMjA0MjAsImV4cCI6MjA3NDg5NjQyMH0.KB5xfyBNcubCksC9bwlKQLvZOPzNALy0UHpQd9B3pXE',
    );
  }
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
