import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/user_profile_view_model.dart';

class ChangeUsernamePopup extends StatelessWidget {
  final TextEditingController controller;
  const ChangeUsernamePopup({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, viewModel, _) => AlertDialog(
        title: Text("Change Username"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            errorText: viewModel.error,
            labelText: "New username",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUsername = controller.text.trim();
              final valid = await viewModel.verifyUsername(newUsername);
              if (valid) {
                await viewModel.changeUsername(newUsername);
                Navigator.pop(context);
              }
            },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }
}
