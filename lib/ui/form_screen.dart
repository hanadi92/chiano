import 'package:chiano/ui/title_bar.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'list_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({required this.apiService, super.key});

  final ApiService apiService;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController(text: 'kopiko_o9');
  final _yearController = TextEditingController(text: '2026');
  final _monthController = TextEditingController(text: '04');

  static final _yearPattern = RegExp(r'^\d{4}$');
  static final _monthPattern = RegExp(r'^(0[1-9]|1[0-2])$');

  @override
  void dispose() {
    _usernameController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final future = widget.apiService.getPGNGamesPerYearMonth(
      username: _usernameController.text.trim(),
      year: _yearController.text.trim(),
      month: _monthController.text.trim(),
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ListScreen(gamesFuture: future),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleBar(
        title: 'Find a game',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    hintText: 'yyyy',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || !_yearPattern.hasMatch(value.trim())) {
                      return 'Enter a 4-digit year, e.g. 2026';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _monthController,
                  decoration: const InputDecoration(
                    labelText: 'Month',
                    hintText: 'mm',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || !_monthPattern.hasMatch(value.trim())) {
                      return 'Enter a 2-digit month, e.g. 08';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
