import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/user_profile_view_model.dart';

/// Dialog widget for changing the user's username.
/// Provides real-time validation and error display using Provider pattern.
class ChangeUsernamePopup extends StatelessWidget {
  /// Text controller for the username input field
  final TextEditingController controller;

  /// Creates a new username change popup dialog
  const ChangeUsernamePopup({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, viewModel, _) => AlertDialog(
        title: Text("Change Username"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            // Display validation errors from the view model
            errorText: viewModel.error,
            labelText: "New username",
          ),
        ),
        actions: [
          // Cancel button - closes dialog without changes
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          // Change button - validates and updates username if valid
          ElevatedButton(
            onPressed: () async {
              final newUsername = controller.text.trim();

              // Verify username meets requirements and is unique
              final valid = await viewModel.verifyUsername(newUsername);

              if (valid) {
                // Update username in database and close dialog
                await viewModel.changeUsername(newUsername);
                Navigator.pop(context);
              }
              // If invalid, error will be displayed via viewModel.error
            },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }
}
