import 'package:chiano/controllers/theme_controller.dart';
import 'package:chiano/services/api_service.dart';
import 'package:chiano/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  final themeController = ThemeController();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeController,
      child: MyApp(apiService: ApiService(http.Client())),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiService, super.key});

  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeController>().themeMode;

    return MaterialApp(
      title: 'Chiano',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0B12),
      ),
      themeMode: themeMode,
      home: HomeScreen(apiService: apiService),
    );
  }
}
