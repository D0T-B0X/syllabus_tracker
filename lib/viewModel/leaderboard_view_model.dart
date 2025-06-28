import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ViewModel for managing leaderboard data and state.
/// Handles fetching user data from Supabase and maintaining the sorted leaderboard.
class LeaderboardViewModel with ChangeNotifier {
  /// Loading state indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Error message storage
  String? _error;
  String? get error => _error;

  /// Map storing user data with UID as key and user info as value
  /// Structure: {'uid': {'topics_completed': int, 'username': string}}
  final Map<String, Map<String, dynamic>> _userDataMap = {};
  Map<String, Map<String, dynamic>> get userDataMap => _userDataMap;

  /// Loads username and topics completed data for all users from Supabase.
  /// Data is automatically sorted by topics_completed in descending order.
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch all user data sorted by topics completed (highest first)
      final response = await Supabase.instance.client
          .from('user_data')
          .select()
          .order('topics_completed', ascending: false);

      // Clear existing data before loading new data
      _userDataMap.clear();

      // Populate the user data map
      for (var row in response) {
        String uid = row['user_id'];
        _userDataMap[uid] = {
          'topics_completed': row['topics_completed'],
          'username': row['username'],
        };
      }
    } catch (e) {
      // Store error message for display to user
      _error = e.toString();
    }

    // Reset loading state and notify listeners
    _isLoading = false;
    notifyListeners();
  }
}
