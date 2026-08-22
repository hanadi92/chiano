import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/theme_controller.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: themeController.toggle,
          icon: Icon(
            themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: themeController.isDarkMode
              ? 'Switch to light mode'
              : 'Switch to dark mode',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
