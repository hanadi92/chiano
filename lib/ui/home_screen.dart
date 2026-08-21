import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.apiService,
    required this.onToggleTheme,
    required this.isDarkMode,
    super.key,
  });

  final ApiService apiService;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chiano'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(
              isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => FormScreen(apiService: apiService),
                  ),
                );
              },
              child: const Text('Pick a game to hear'),
            ),
          ),
        ),
      ),
    );
  }
}

