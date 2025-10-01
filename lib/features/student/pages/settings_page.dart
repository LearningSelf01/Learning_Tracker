import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _CenteredText('Customize your app settings here.');
  }
}

class _CenteredText extends StatelessWidget {
  const _CenteredText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
      ),
    );
  }
}
