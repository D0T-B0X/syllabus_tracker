import 'package:flutter/material.dart';
import 'package:syllabus_tracker/viewModel/splash_screen_view_model.dart';
import 'package:provider/provider.dart';

/// Splash screen view that determines navigation based on authentication state.
class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to check if the user is logged in
    return FutureBuilder(
      future: Provider.of<SplashScreenViewModel>(
        context,
        listen: false,
      ).isLoggedIn(),
      builder: (context, snapshot) {
        // Show loading indicator while checking authentication
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Navigate to the appropriate screen after checking authentication
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (snapshot.data == true) {
            // If logged in, go to subjects list
            Navigator.of(context).pushReplacementNamed('/subjects');
          } else {
            // If not logged in, go to signup page
            Navigator.of(context).pushReplacementNamed('/signup');
          }
        });
        // Show loading indicator during navigation transition
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
