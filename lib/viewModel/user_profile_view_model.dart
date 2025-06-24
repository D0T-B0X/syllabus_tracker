import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/model/user_profile_model.dart';

class UserProfileViewModel with ChangeNotifier {
  final UserProfileModel _userProfileModel = UserProfileModel(username: "");

  String? _error;

  String? get error => _error;
  String get username => _userProfileModel.username;

  Future<void> loadUsername() async {
    final user = Supabase.instance.client.auth.currentUser;
    final uid = user?.id;

    final response = await Supabase.instance.client
        .from('user_data')
        .select('username')
        .eq('user_id', uid!)
        .single();

    _userProfileModel.username = response['username'];
    notifyListeners();
  }

  Future<void> changeUsername(String displayName) async {
    final user = Supabase.instance.client.auth.currentUser;
    final uid = user?.id;

    final response = await Supabase.instance.client
        .from('user_data')
        .update({'username': displayName})
        .eq('user_id', uid!)
        .select();

    if (response.isNotEmpty) {
      _userProfileModel.username = displayName;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

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
