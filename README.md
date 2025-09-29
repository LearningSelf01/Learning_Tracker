<<<<<<< HEAD
# Learning_Tracker
=======
# Learning Tracker

A simple, student-friendly Flutter app shell built with Riverpod and GoRouter. It features:

- Bottom navigation with 5 tabs
- Left side drawer (sidebar) with styled icons
- Top-right profile icon in the app bar
- Light and Dark Material 3 themes (defaults to system setting)

## Tech Stack

- Flutter (Material 3)
- Riverpod (`flutter_riverpod`) for state management
- GoRouter (`go_router`) for navigation

## Project Structure

- `lib/main.dart` — App entry using `ProviderScope` and `MaterialApp.router`
- `lib/app_router.dart` — Centralized GoRouter routes and shell layout
- `lib/theme.dart` — Light and dark theme builders
- `lib/features/home/` — App shell (AppBar, Drawer, Bottom Nav)
  - `home_page.dart` — `HomeShell` scaffold
  - `widgets/app_drawer.dart` — Left drawer with styled icons
- `lib/features/pages/` — Placeholder pages for tabs
  - `dashboard_page.dart`, `courses_page.dart`, `calendar_page.dart`, `tasks_page.dart`, `settings_page.dart`

## Run

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the app on a device/emulator:
   ```bash
   flutter run
   ```

## Navigation

- Bottom tabs: Dashboard, Courses, Calendar, Tasks, Settings
- Drawer provides the same destinations with modern, filled icons
- Top-right profile icon currently shows a snack bar (placeholder action)

## Theming

Themes live in `lib/theme.dart` and use Material 3 with a friendly indigo seed color. The app uses `ThemeMode.system` by default so it matches the device theme.
>>>>>>> bae853a (Base Development)
