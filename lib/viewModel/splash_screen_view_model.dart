import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ViewModel for splash screen logic, handling authentication state checks.
/// Determines whether to show login screen or main app based on existing session.
class SplashScreenViewModel with ChangeNotifier {
  /// Checks if the user is currently logged in by verifying session existence.
  ///
  /// Returns true if a valid session exists, false otherwise.
  /// Used by splash screen to determine initial navigation route.
  Future<bool> isLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }
}
