import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/model/auth_model.dart';

//╔══════════════════════════════════════════════════════════════════════════╗
//║ AUTH VIEW MODEL                                                          ║
//║ Manages authentication logic, credential validation, sign up, and        ║
//║ Supabase auth operations for the syllabus tracker application.           ║
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
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Error message for sign up or sign in
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Success state for sign up
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  //┌─────────────────────────────────────────────┐
  //│ VALIDATION METHODS                          │
  //└─────────────────────────────────────────────┘

  /// Validates email format
  ///
  /// • Checks for @ symbol
  void verifyEmail(String email) {
    if (!email.contains('@')) {
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
          "Password must have more than 8 characters, at least one\nuppercase, one lowercase, one numerical and one\nspecial character";
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
    _isLoading = true;
    notifyListeners();

    try {
      // Attempt Supabase authentication
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email.value!,
        password: password.value!,
      );

      _isLoading = false;
      notifyListeners();

      // Return true if user is authenticated
      return response.user != null;
    } catch (e) {
      // Handle authentication failure and set error message
      _isLoading = false;
      String errorMsg = "Login Failed";
      if (e is AuthException) {
        errorMsg = "Login failed: ${e.message}";
      } else if (e is AuthApiException) {
        errorMsg = "Login failed: ${e.message}";
      } else if (e is Exception) {
        errorMsg = "Login failed: ${e.toString().split(':').last.trim()}";
      }
      _authEmail.error = errorMsg;
      _errorMessage = errorMsg;
      notifyListeners();
      return false;
    }
  }

  /// Registers a new user with Supabase
  Future<void> registerUser(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Attempt Supabase sign up
      final response = await Supabase.instance.client.auth.signUp(
        // name: name,
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId != null) {
        await Supabase.instance.client.from('user_data').insert({
          // .rpc('insert_display_name_profile', params: {
          'user_id': userId,
          'username': name,
        });
      }
    } catch (e) {
      // Handle sign up failure and set error message
      String errorMsg = "SignUp Failed";
      if (e is AuthException) {
        errorMsg = "SignUp failed: ${e.message}";
      } else if (e is AuthApiException) {
        errorMsg = "SignUp failed: ${e.message}";
      } else if (e is Exception) {
        errorMsg = "SignUp failed: ${e.toString().split(':').last.trim()}";
      }
      _errorMessage = errorMsg;
      _isSuccess = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles sign up button logic, including password confirmation
  Future<void> signUpButton(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    // Check if password and confirm password match
    if (password != confirmPassword) {
      _errorMessage = "'Password' and 'Confirm Password' are different";
      _isSuccess = false;
      notifyListeners();
      return;
    } else {
      try {
        _isLoading = true;
        notifyListeners();
        await registerUser(name, email, password);
        _isSuccess = true;
        _errorMessage = null;
        notifyListeners();
      } catch (e) {
        // Error already handled in registerUser
        _isSuccess = false;
        notifyListeners();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Clears error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Resets success state
  void resetSuccess() {
    _isSuccess = false;
    notifyListeners();
  }

  /// Returns the username of the currently logged in user
  Future<String?> getUsername() async {
    final User? user = Supabase.instance.client.auth.currentUser;
    final String? uid = user?.id;

    final userResponse = await Supabase.instance.client
        .from('user_data')
        .select('username')
        .eq('user_id', uid!)
        .single();

    String? displayName;

    if (userResponse.isNotEmpty) {
      displayName = userResponse['username'];
    }

    return displayName;
  }
}
