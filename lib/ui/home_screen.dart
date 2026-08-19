import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.apiService, super.key});

  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

