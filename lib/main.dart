import 'package:chiano/services/api_service.dart';
import 'package:chiano/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp(apiService: ApiService(http.Client())));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiService, super.key});

  final ApiService apiService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(apiService: apiService,),
    );
  }
}
