import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/model/auth_model.dart';

class AuthViewModel with ChangeNotifier {
  final AuthModel _authEmail = AuthModel(value: null, error: null);
  final AuthModel _authPassword = AuthModel(value: null, error: null);

  AuthModel get email => _authEmail;
  AuthModel get password => _authPassword;

  bool isLoading = false;

  void verifyEmail(String email) {
    if (!email.contains('@') || !email.contains(".com")) {
      _authEmail.error = "Enter a valid email";
    } else {
      _authEmail.error = null;
      _authEmail.value = email;
    }

    notifyListeners();
  }

  void verifyPassword(String password) {
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _authPassword.error =
          "Password must have atleast one uppercase, one lowercase, one numerical and one special character";
    } else {
      _authPassword.error = null;
      _authPassword.value = password;
    }

    notifyListeners();
  }

  Future<bool> signIn() async {
    if (email.value == null ||
        password.value == null ||
        email.error != null ||
        password.error != null) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email.value!,
        password: password.value!,
      );

      isLoading = false;
      notifyListeners();

      return response.user != null;
    } catch (e) {
      isLoading = false;
      _authEmail.error = "Login failed: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }
}
