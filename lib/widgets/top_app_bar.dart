import 'package:flutter/material.dart';

/// Custom app bar widget that provides consistent styling across the app.
/// Displays a centered page title with no back button.
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar
  final String pageName;

  /// Creates a new top app bar with the specified page name
  const TopAppBar({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Disable automatic back button
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          pageName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Required implementation for PreferredSizeWidget
  /// Returns the standard toolbar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
