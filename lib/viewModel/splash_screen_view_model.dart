import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ViewModel for splash screen logic, such as checking authentication state.
class SplashScreenViewModel with ChangeNotifier {
  /// Checks if the user is currently logged in (has a valid session).
  ///
  /// Returns true if a session exists, false otherwise.
  Future<bool> isLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }
}
