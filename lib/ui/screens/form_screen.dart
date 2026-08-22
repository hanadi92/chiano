import 'package:chiano/ui/components/title_bar.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
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
      MaterialPageRoute<void>(builder: (_) => ListScreen(gamesFuture: future)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleBar(title: 'Find a game'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let’s find your game',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your Chess.com details and choose the month you played.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                _buildField(
                  controller: _usernameController,
                  label: 'Chess.com username',
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _yearController,
                        label: 'Year',
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null ||
                              !_yearPattern.hasMatch(value.trim())) {
                            return 'Use yyyy';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildField(
                        controller: _monthController,
                        label: 'Month',
                        icon: Icons.date_range_outlined,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null ||
                              !_monthPattern.hasMatch(value.trim())) {
                            return 'Use mm';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Find my games', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        counterText: '',
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
    );
  }
}
