import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> registerUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception("SignUp Failed");
      }
    } finally {
    _isLoading = false;
    notifyListeners();
    }
  }


  String? _errorMessage;
  bool _isSuccess = false;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetSuccess() {
    _isSuccess = false;
    notifyListeners();
  }

  Future<void> SignUpButton(String email, String password, String confirmPassword) async {

    if (password != confirmPassword) {
      _errorMessage = "'Password' and 'Confirm Password' are different";
      notifyListeners();
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      await registerUser(email, password);
      _isSuccess = true;
      _errorMessage = null;
      notifyListeners();
          // content: Text("SignUp Successful"),
    } catch (e) {
      // Text("SignUp Failed")
      _errorMessage = "SignUp Failed";
      // _isLoading = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}