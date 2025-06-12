import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/model/auth_model.dart';

//╔══════════════════════════════════════════════════════════════════════════╗
//║ AUTH VIEW MODEL                                                          ║
//║                                                                          ║
//║ Manages authentication logic, credential validation, and Supabase auth   ║
//║ operations for the syllabus tracker application.                         ║
//╚══════════════════════════════════════════════════════════════════════════╝
class AuthViewModel with ChangeNotifier {
  //┌─────────────────────────────────────────────┐
  //│ STATE MANAGEMENT                            │
  //└─────────────────────────────────────────────┘

  /// Email model holding value and validation state
  final AuthModel _authEmail = AuthModel(value: null, error: null);

  /// Password model holding value and validation state
  final AuthModel _authPassword = AuthModel(value: null, error: null);

  /// Public access to email state
  AuthModel get email => _authEmail;

  /// Public access to password state
  AuthModel get password => _authPassword;

  /// Loading indicator for async operations
  bool isLoading = false;

  //┌─────────────────────────────────────────────┐
  //│ VALIDATION METHODS                          │
  //└─────────────────────────────────────────────┘

  /// Validates email format
  ///
  /// • Checks for @ symbol
  /// • Verifies .com domain presence
  void verifyEmail(String email) {
    if (!email.contains('@') || !email.contains(".com")) {
      _authEmail.error = "Enter a valid email";
    } else {
      _authEmail.error = null;
      _authEmail.value = email;
    }

    notifyListeners();
  }

  /// Validates password strength
  ///
  /// • Minimum length: 8 characters
  /// • Must contain: uppercase, lowercase, number, special char
  void verifyPassword(String password) {
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) || // Uppercase check
        !password.contains(RegExp(r'[a-z]')) || // Lowercase check
        !password.contains(RegExp(r'[0-9]')) || // Number check
        !password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      // Special char check
      _authPassword.error =
          "Password must have at least one uppercase, one lowercase, one numerical and one special character";
    } else {
      _authPassword.error = null;
      _authPassword.value = password;
    }

    notifyListeners();
  }

  //┌─────────────────────────────────────────────┐
  //│ AUTHENTICATION METHODS                      │
  //└─────────────────────────────────────────────┘

  /// Signs in user with validated credentials
  ///
  /// Returns true if authentication succeeds
  Future<bool> signIn() async {
    // Verify credentials are valid before attempting login
    if (email.value == null ||
        password.value == null ||
        email.error != null ||
        password.error != null) {
      return false;
    }

    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      // Attempt Supabase authentication
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email.value!,
        password: password.value!,
      );

      // Reset loading and return result
      isLoading = false;
      notifyListeners();

      return response.user != null;
    } catch (e) {
      // Handle authentication failure
      isLoading = false;
      _authEmail.error = "Login failed: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // TODO: Add signUp method
  // TODO: Add signOut method
  // TODO: Add passwordReset method
}
