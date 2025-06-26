import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/model/user_profile_model.dart';

class UserProfileViewModel with ChangeNotifier {
  /// userprofile model instance
  final UserProfileModel _userProfileModel = UserProfileModel(username: "");

  /// error variable
  String? _error;

  /// getter function to make the value in _error public
  String? get error => _error;

  /// getter function to make the value in username public
  String get username => _userProfileModel.username;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// loads the username of the current user
  Future<void> loadUsername() async {
    _isLoading = true;
    notifyListeners();

    /// current user instance
    final user = Supabase.instance.client.auth.currentUser;

    /// current user's uid
    final uid = user?.id;

    final response = await Supabase.instance.client
        .from('user_data')
        .select('username')
        .eq('user_id', uid!)
        .single();

    _userProfileModel.username = response['username'];

    _isLoading = false;
    notifyListeners();
  }

  /// replaces the username of the current user by a new user provided username
  /// in the user_data table
  Future<void> changeUsername(String displayName) async {
    _isLoading = true;
    notifyListeners();

    final user = Supabase.instance.client.auth.currentUser;
    final uid = user?.id;

    final response = await Supabase.instance.client
        .from('user_data')
        .update({'username': displayName})
        .eq('user_id', uid!)
        .select();

    if (response.isNotEmpty) {
      _userProfileModel.username = displayName;

      _isLoading = false;
      notifyListeners();
    }
  }

  /// signs the current user out
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  /// ensure the username is valid and unique
  Future<bool> verifyUsername(String cUsername) async {
    final response = await Supabase.instance.client
        .from('user_data')
        .select()
        .eq('username', cUsername)
        .maybeSingle();

    if (cUsername.length < 6) {
      _error = "Username must be atleast 6 characters";
      notifyListeners();

      return false;
    } else if (response != null) {
      _error = "Username already taken. Please try again.";
      notifyListeners();

      return false;
    } else {
      _error = null;
      notifyListeners();

      return true;
    }
  }
}
